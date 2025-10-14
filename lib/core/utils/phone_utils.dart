import 'dart:developer' as dev;
import 'package:contacts_service_plus/contacts_service_plus.dart';

/// PhoneUtils — تحسين متقدم للتطبيع (normalize) والمطابقة من دون مكتبات خارجية.
/// ملاحظة: هذا حل عملي ودقيق لمعظم الحالات، لكنه ليس بديلاً كاملاً لمكتبات متخصصة
/// (مثل libphonenumber) عندما تحتاج دقة 100% لكل استثناءات دولية.
class PhoneUtils {
  static final Map<String, String> _cache = {};

  /// خريطة ISO -> calling code و trunkPrefix (إذا وُجد).
  /// يمكن توسيعها حسب حاجتك. أدرجت مجموعة كبيرة من الدول الشائعة.
  static const Map<String, Map<String, String>> _countryMeta = {
    'EG': {'code': '20', 'trunk': '0'},
    'SA': {'code': '966', 'trunk': '0'},
    'AE': {'code': '971', 'trunk': '0'},
    'JO': {'code': '962', 'trunk': '0'},
    'KW': {'code': '965', 'trunk': '0'},
    'QA': {'code': '974', 'trunk': '0'},
    'OM': {'code': '968', 'trunk': '0'},
    'BH': {'code': '973', 'trunk': '0'},
    'LY': {'code': '218', 'trunk': '0'},
    'SD': {'code': '249', 'trunk': '0'},
    'DZ': {'code': '213', 'trunk': '0'},
    'MA': {'code': '212', 'trunk': '0'},
    'TN': {'code': '216', 'trunk': '0'},
    'IQ': {'code': '964', 'trunk': '0'},
    'TR': {'code': '90', 'trunk': '0'},
    'US': {'code': '1', 'trunk': ''},    // NANP لا يستخدم 0 كـ trunk داخلي
    'CA': {'code': '1', 'trunk': ''},
    'GB': {'code': '44', 'trunk': '0'},
    'FR': {'code': '33', 'trunk': '0'},
    'DE': {'code': '49', 'trunk': '0'},
    'IN': {'code': '91', 'trunk': '0'},
    'PK': {'code': '92', 'trunk': '0'},
    'NG': {'code': '234', 'trunk': '0'},
    'AU': {'code': '61', 'trunk': '0'},
    'NZ': {'code': '64', 'trunk': '0'},
    'BR': {'code': '55', 'trunk': '0'},
    // أضف أو عدّل حسب جمهور تطبيقك...
  };

  /// Länder list (iso codes) يستخدم كترتيب افتراضي للتجريب.
  static List<String> _allowedIsoCodes = _countryMeta.keys.toList();

  /// بناء خريطة من رموز الدول (country calling codes) لراحتنا عند البحث السريع.
  /// تُنشأ لأول مرة.
  static Map<String, String>? _callingCodeToIsoCache;
  static Map<String, String> get _callingCodeToIso {
    if (_callingCodeToIsoCache != null) return _callingCodeToIsoCache!;
    final map = <String, String>{};
    _countryMeta.forEach((iso, meta) {
      final code = meta['code']!;
      map[code] = iso;
    });
    // نجعل البحث أسهل عن طريق فرز مفاتيح الأكواد (طوليا) عند الماتش
    _callingCodeToIsoCache = map;
    return _callingCodeToIsoCache!;
  }

  /// تعديل قائمة الدول المسموح بها (مثلاً من إعدادات السيرفر)
  static void setAllowedCountries(List<String> isoCodes) {
    final normalized = isoCodes.map((e) => e.toUpperCase()).where((e) => _countryMeta.containsKey(e)).toList();
    if (normalized.isNotEmpty) {
      _allowedIsoCodes = normalized;
      dev.log('PhoneUtils: allowed ISOs set: $_allowedIsoCodes');
    }
  }

  /// تنظيف أساسي + استبدال بادئات دولية شائعة
  static String _clean(String input) {
    if (input == null) return '';
    var s = input.trim();
    // نستبدل unicode + variations لو ظهرت
    s = s.replaceAll(RegExp(r'[^\d\+]'), ''); // اترك الأرقام و +
    // handle leading 011 (NANP international dial) -> treat as international prefix
    if (s.startsWith('011')) {
      s = '+${s.substring(3)}';
    }
    // leading 00 -> +
    if (s.startsWith('00')) {
      s = '+${s.substring(2)}';
    }
    return s;
  }

  /// محاولة اكتشاف الدولة إذا الرقم دولي (يبدأ بـ +)
  static String? _detectIsoFromInternational(String plusNumber) {
    // نزيل +
    String digits = plusNumber.startsWith('+') ? plusNumber.substring(1) : plusNumber;
    // نجرب الأكواد الأكثر طولًا أولاً (مثلاً 1، 20، 212، 213 ... لكن نفحص الطول الأكبر أولاً)
    final codes = _callingCodeToIso.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length)); // طول تنازلي
    for (final code in codes) {
      if (digits.startsWith(code)) {
        return _callingCodeToIso[code];
      }
    }
    return null;
  }

  /// إنتاج نسخة E.164 من رقم؛ يحاول قدر الإمكان عبر استراتيجيات متعددة.
  /// defaultIso: بلد افتراضي لاستكمال الأرقام المحلية.
  static String normalizePhone(String? phone, {String defaultIso = 'EG'}) {
    if (phone == null || phone.trim().isEmpty) return '';

    final cleaned0 = _clean(phone);
    if (cleaned0.isEmpty) return '';

    // cache key use original cleaned (so +... and variations stored separately)
    if (_cache.containsKey(cleaned0)) return _cache[cleaned0]!;

    String result = cleaned0;

    // 1) لو عندنا + فهي دولية: نرتبها لتبدأ بـ +
    if (result.startsWith('+')) {
      // Normalize: + then digits (already)
      _cache[cleaned0] = result;
      return result;
    }

    // 2) إذا بعد التنظيف لا يوجد + -> محلي أو مع بادئة غير معروفة
    // نحاول استراتيجيات متعددة بالأولوية:
    // Strategy A: إذا الرقم يبدأ ببعض الأصفار الزائدة (مثل 00 handled) أو 0 -> نحزيل الـ trunk ونضيف الكود
    final isoCandidates = <String>[defaultIso] + _allowedIsoCodes.where((e) => e != defaultIso).toList();

    for (final iso in isoCandidates) {
      final meta = _countryMeta[iso];
      if (meta == null) continue;
      final code = meta['code']!;
      final trunk = meta['trunk'] ?? '';

      // محاولة 1: لو الرقم يبدأ بـ trunk (مثلاً 0) → نزيله ثم نضيف رمز البلد
      String afterTrunk = result;
      if (trunk.isNotEmpty && afterTrunk.startsWith(trunk)) {
        afterTrunk = afterTrunk.substring(trunk.length);
      }
      // محاولة 2: لو الرقم لا يبدأ بـ trunk، جربه كما هو
      final candidate1 = '+$code$afterTrunk';
      final candidate2 = '+$code$result';

      // heuristics: نفضّل الشكل الذي يعطي طول منطقي (بين 7 و 15 أرقام بعد +)
      bool validCandidate(String cand) {
        final digits = cand.replaceAll('+', '');
        return digits.length >= 7 && digits.length <= 15;
      }

      if (validCandidate(candidate1)) {
        _cache[cleaned0] = candidate1;
        return candidate1;
      }
      if (validCandidate(candidate2)) {
        _cache[cleaned0] = candidate2;
        return candidate2;
      }
      // إذا لم ينجح أي منهما، نواصل التجريب مع بلد آخر
    }

    // 3) كحل أخير: إذا لم نقدر نحدّد بشكل مقنع، نحاول إضافة default بدون إزالة trunk
    final fallbackPrefix = _countryMeta[defaultIso]?['code'] ?? '20';
    final fallback = '+$fallbackPrefix$result';
    _cache[cleaned0] = fallback;
    return fallback;
  }

  /// مقارنة سريعة بين رقمين: نحاول عدة استراتيجيات (normalize مباشر، ثم تجريب iso allowed)
  static bool arePhonesEqual(String? a, String? b, {List<String>? isoCodes, String defaultIso = 'EG'}) {
    if (a == null || b == null) return false;
    final cleanedA = _clean(a);
    final cleanedB = _clean(b);
    if (cleanedA.isEmpty || cleanedB.isEmpty) return false;

    // نفس السلسلة بعد التنظيف (مثل +2010... و +2010...) -> true مباشرة
    if (cleanedA == cleanedB) return true;

    // محاولة normalizing مع defaultIso سريعاً
    final nA = normalizePhone(a, defaultIso: defaultIso);
    final nB = normalizePhone(b, defaultIso: defaultIso);
    if (nA == nB) return true;

    // نجرب عبر مجموعة الدول (isoCodes param أو المفعّلة)
    final countries = isoCodes ?? _allowedIsoCodes;
    for (final iso in countries) {
      final nnA = normalizePhone(a, defaultIso: iso);
      final nnB = normalizePhone(b, defaultIso: iso);
      if (nnA == nnB) return true;
    }

    // كنقطة أخيرة: إذا أحدهما يبدأ بـ + ونفس الباقي (بعد إزالة code) -> تحقق بسيط
    String stripCountry(String plusNumber) {
      if (!plusNumber.startsWith('+')) return plusNumber;
      final digits = plusNumber.substring(1);
      // remove matched calling code
      final codes = _callingCodeToIso.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
      for (final code in codes) {
        if (digits.startsWith(code)) {
          return digits.substring(code.length);
        }
      }
      return digits;
    }

    final sA = stripCountry(nA);
    final sB = stripCountry(nB);
    if (sA == sB) return true;

    return false;
  }

  /// إيجاد جهة اتصال: يجرب المقارنة بطريقة فعّالة (يقارن normalized forms)
  static Future<Contact?> findContactByPhone(String? phone, List<Contact> allContacts, {String defaultIso = 'EG'}) async {
    if (phone == null || phone.trim().isEmpty) return null;
    final normalizedTarget = normalizePhone(phone, defaultIso: defaultIso);

    for (final contact in allContacts) {
      for (final p in contact.phones ?? []) {
        final candidate = p.value ?? '';
        // مقارنة سريعة جدًا: أولاً نفس السلسلة بعد تنظيف
        if (_clean(candidate) == _clean(phone)) return contact;
        // ثم المقارنة المتقدمة
        if (arePhonesEqual(normalizedTarget, candidate, defaultIso: defaultIso)) {
          dev.log('✅ تطابق: ${contact.displayName} ↔ $phone');
          return contact;
        }
      }
    }
    return null;
  }

  static void clearCache() {
    _cache.clear();
    _callingCodeToIsoCache = null;
    dev.log('PhoneUtils: cache cleared');
  }

  static int get cacheSize => _cache.length;
}
