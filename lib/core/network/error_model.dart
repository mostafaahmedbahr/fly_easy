import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ErrorModel extends Equatable {
  const ErrorModel();

  String getErrorMessage(Object error, {List<String>? keys}) {
    if(error is FirebaseException){
      return error.code;
    }
   else if (error is DioException) {
      if (kDebugMode) {
        print(error.response);
      }
      if (error.response != null) {
        if (error.response!.statusCode == 422) {
          return _ValidationErrorModel.getValidationMessage(
              response: error.response!, keys: keys ?? []);
        } else if (error.response!.data['message'] != null) {
          return error.response!.data['message'];
        } else {
          return AppStrings.errorMessage;
        }
      } else {
        return _DioExceptionErrors.getErrorMessage(error);
      }
    } else {
      if (kDebugMode) {
        print(error);
      }
      return AppStrings.errorMessage;
    }
  }

  @override
  List<Object?> get props => [];
}

class _ValidationErrorModel {
  static String getValidationMessage(
      {required Response response, required List<String> keys}) {
    if (response.data != null && response.data['errors'] != null) {
      for (var key in keys) {
        if (response.data['errors'][key] != null) {
          return _validationErrors[response.data['errors'][key][0]]??'';
        }
      }
    }
    return AppStrings.errorMessage;
  }

static final Map<String,String>_validationErrors={
  "email_used_before": LocaleKeys.email_used_before.tr(),
  "phone_used_before": LocaleKeys.phone_used_before.tr(),
  "email_required": LocaleKeys.email_required.tr(),
  "email_format_not_valid": LocaleKeys.email_format_not_valid.tr(),
  "email_not_found": LocaleKeys.email_not_found.tr(),
  "name_required": LocaleKeys.name_required.tr(),
  "name_min_3": LocaleKeys.name_min_3.tr(),
  "name_max_100": LocaleKeys.name_max_100.tr(),
  "name_found": LocaleKeys.name_found.tr(),
  "name_not_correct": LocaleKeys.name_not_correct.tr(),
  "moderators_in_guests": LocaleKeys.moderators_in_guests.tr(),
  "moderators_format_not_valid": LocaleKeys.moderators_format_not_valid.tr(),
  "moderators_min_1": LocaleKeys.moderators_min_1.tr(),
  "moderator_required": LocaleKeys.moderator_required.tr(),
  "moderator_not_found": LocaleKeys.moderator_not_found.tr(),
  "guests_format_not_valid": LocaleKeys.guests_format_not_valid.tr(),
  "guests_min_1": LocaleKeys.guests_min_1.tr(),
  "guest_required": LocaleKeys.guest_required.tr(),
  "guest_not_found": LocaleKeys.guest_not_found.tr(),
  "guests_in_moderators": LocaleKeys.guests_in_moderators.tr(),
  "authenticated_user_in_guests": "",
  "authenticated_user_in_moderators": "",
  "logo_max_3_mb": LocaleKeys.logo_max_3_mb.tr(),
  "name_format_not_valid": LocaleKeys.name_format_not_valid.tr(),
  "name_max_50": LocaleKeys.name_max_50.tr(),
  "phone_required": LocaleKeys.phone_required.tr(),
  "phone_format_not_valid": LocaleKeys.phone_format_not_valid.tr(),
  "password_format_not_valid": LocaleKeys.password_format_not_valid.tr(),
  "password_min_6": LocaleKeys.password_min_6.tr(),
  "password_max_30": LocaleKeys.password_max_30.tr(),
  "code_required": LocaleKeys.code_required.tr(),
  "code_not_correct": LocaleKeys.code_not_correct.tr(),
  "can_not_add_team": LocaleKeys.can_not_add_team.tr(),
  "can_not_add_community":LocaleKeys.can_not_add_community.tr(),
  "can_not_add_sub_community": LocaleKeys.can_not_add_sub_community.tr(),
  "logo_must_be_file": LocaleKeys.logo_must_be_file.tr(),
  "logo_not_supported": LocaleKeys.logo_not_supported.tr(),
  "image_required": LocaleKeys.image_required.tr(),
  "image_must_be_file": LocaleKeys.image_must_be_file.tr(),
  "image_not_supported": LocaleKeys.image_not_supported.tr(),
  "image_max_3_mb": LocaleKeys.image_max_3_mb.tr(),
};
}

class _DioExceptionErrors {
  static String getErrorMessage(DioException error) {
    if (error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AppStrings.checkInternet;
    } else {
      return AppStrings.errorMessage;
    }
  }
}
