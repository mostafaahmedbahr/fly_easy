// lib/core/utils/phone_utils.dart

import 'package:contacts_service_plus/contacts_service_plus.dart';

class PhoneUtils {
  /// 🌍 رموز الدول الشائعة
  static const Map<String, String> countryCodes = {
    'EG': '20', // مصر
    'SA': '966', // السعودية
    'AE': '971', // الإمارات
    'KW': '965', // الكويت
    'QA': '974', // قطر
    'BH': '973', // البحرين
    'OM': '968', // عمان
    'JO': '962', // الأردن
    'LB': '961', // لبنان
    'SY': '963', // سوريا
    'IQ': '964', // العراق
    'DZ': '213', // الجزائر
    'MA': '212', // المغرب
    'TN': '216', // تونس
    'SD': '249', // السودان
    'LY': '218', // ليبيا
    'YE': '967', // اليمن
    'US': '1', // الولايات المتحدة
    'GB': '44', // بريطانيا
    'FR': '33', // فرنسا
    'DE': '49', // ألمانيا
    'IT': '39', // إيطاليا
    'RU': '7', // روسيا
    'IN': '91', // الهند
    'CN': '86', // الصين
    'JP': '81', // اليابان
    'BR': '55', // البرازيل
  };

  /// 🔢 تنظيف وتوحيد تنسيق الرقم (دولي)
  static String? normalizePhone(String? phone) {
    if (phone == null || phone.isEmpty) return null;

    try {
      // إزالة جميع المسافات والأحرف الخاصة
      String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      // معالجة البادئات الدولية
      if (cleaned.startsWith('00')) {
        cleaned = cleaned.substring(2);
      } else if (cleaned.startsWith('+')) {
        cleaned = cleaned.substring(1);
      }

      // إزالة الأصفار الزائدة في البداية (ماعدا الرقم 0 نفسه)
      if (cleaned.length > 1 && cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }

      return cleaned.isNotEmpty ? cleaned : null;
    } catch (e) {
      print('⚠️ خطأ في معالجة الرقم: $phone - $e');
      return null;
    }
  }

  /// 🔍 استخراج رمز الدولة من الرقم
  static String? extractCountryCode(String phone) {
    final normalized = normalizePhone(phone);
    if (normalized == null) return null;

    // البحث عن رمز الدولة المطابق
    for (final code in countryCodes.values) {
      if (normalized.startsWith(code)) {
        return code;
      }
    }

    return null;
  }

  /// 🌍 تحديد الدولة من الرقم
  static String? detectCountry(String phone) {
    final countryCode = extractCountryCode(phone);
    if (countryCode == null) return null;

    return countryCodes.entries
        .firstWhere(
          (entry) => entry.value == countryCode,
      orElse: () => const MapEntry('', ''),
    )
        .key;
  }

  /// 🎯 توليد جميع الصيغ المحتملة للرقم للمقارنة
  static Set<String> generateAllPhoneFormats(String? phone) {
    final formats = <String>{};
    if (phone == null) return formats;

    final normalized = normalizePhone(phone);
    if (normalized == null) return formats;

    final countryCode = extractCountryCode(normalized);
    final country = detectCountry(normalized);

    // الصيغة الأساسية (بدون رموز)
    formats.add(normalized);

    if (countryCode != null) {
      // الصيغ المختلفة مع رمز الدولة
      formats.add('+$countryCode${_getLocalNumber(normalized, countryCode)}');
      formats.add('00$countryCode${_getLocalNumber(normalized, countryCode)}');
      formats.add('0${_getLocalNumber(normalized, countryCode)}'); // الصيغة المحلية

      // الصيغة بدون رمز الدولة
      final localNumber = _getLocalNumber(normalized, countryCode);
      if (localNumber != normalized) {
        formats.add(localNumber);
      }
    } else {
      // إذا لم يتم التعرف على رمز الدولة، نجرب الصيغ الشائعة
      _addCommonFormats(formats, normalized);
    }

    // إضافة الصيغة بدون أي رموز
    final digitsOnly = normalized.replaceAll(RegExp(r'[^\d]'), '');
    formats.add(digitsOnly);

    return formats;
  }

  /// 📞 استخراج الرقم المحلي بعد إزالة رمز الدولة
  static String _getLocalNumber(String normalizedPhone, String countryCode) {
    if (normalizedPhone.startsWith(countryCode)) {
      return normalizedPhone.substring(countryCode.length);
    }
    return normalizedPhone;
  }

  /// ➕ إضافة الصيغ الشائعة للأرقام بدون رمز دولة معروف
  static void _addCommonFormats(Set<String> formats, String normalized) {
    // جرب جميع رموز الدول الشائعة في المنطقة
    const middleEastCodes = ['20', '966', '971', '965', '974', '973', '968', '962', '961'];

    for (final code in middleEastCodes) {
      if (!normalized.startsWith(code)) {
        formats.add('+$code$normalized');
        formats.add('00$code$normalized');
      }
    }

    // الصيغ المحلية (تبدأ بـ 0)
    if (!normalized.startsWith('0')) {
      formats.add('0$normalized');
    }
  }

  /// 🎯 البحث عن جهة اتصال مطابقة مع جميع الصيغ
  static Contact? findContactByPhone(
      String? phone,
      List<Contact> allContacts
      ) {
    if (phone == null || allContacts.isEmpty) return null;

    final searchFormats = generateAllPhoneFormats(phone);

    print('🔍 البحث عن: $phone');
    print('   📱 الصيغ المحتملة: $searchFormats');

    for (final contact in allContacts) {
      for (final contactPhone in contact.phones ?? []) {
        final contactFormats = generateAllPhoneFormats(contactPhone.value);

        // البحث عن تطابق بين مجموعتي الصيغ
        final match = searchFormats.intersection(contactFormats);
        if (match.isNotEmpty) {
          print('✅ تم العثور على تطابق: $phone ↔ ${contactPhone.value}');
          print('   👤 اسم جهة الاتصال: ${contact.displayName}');
          print('   🎯 الصيغ المتطابقة: $match');
          return contact;
        }
      }
    }

    print('❌ لا يوجد تطابق لـ: $phone');
    return null;
  }

  /// 📞 استخراج جميع الأرقام من جهة اتصال
  static List<String> extractAllPhones(Contact contact) {
    final phones = <String>[];
    for (final phone in contact.phones ?? []) {
      final normalized = normalizePhone(phone.value);
      if (normalized != null) {
        phones.add(normalized);
      }
    }
    return phones;
  }

  /// 🏳️ الحصول على اسم الدولة من الرمز
  static String getCountryName(String countryCode) {
    const countryNames = {
      'EG': 'مصر', 'SA': 'السعودية', 'AE': 'الإمارات', 'KW': 'الكويت',
      'QA': 'قطر', 'BH': 'البحرين', 'OM': 'عمان', 'JO': 'الأردن',
      'LB': 'لبنان', 'SY': 'سوريا', 'IQ': 'العراق', 'DZ': 'الجزائر',
      'MA': 'المغرب', 'TN': 'تونس', 'SD': 'السودان', 'LY': 'ليبيا',
      'YE': 'اليمن', 'US': 'الولايات المتحدة', 'GB': 'بريطانيا',
      'FR': 'فرنسا', 'DE': 'ألمانيا', 'IT': 'إيطاليا', 'RU': 'روسيا',
      'IN': 'الهند', 'CN': 'الصين', 'JP': 'اليابان', 'BR': 'البرازيل',
    };

    return countryNames[countryCode] ?? 'غير معروف';
  }
}