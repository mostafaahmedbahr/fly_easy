import 'package:dio/dio.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class RegisterErrorModel {
  static String getErrorMessage(Response? response) {
    if(response!=null && response.data!=null && response.statusCode==422){
      if (response.data['errors']['email'] != null) {
        return response.data['errors']['email'][0];
      } else if (response.data['errors']['password'] != null) {
        return response.data['errors']['password'][0];
      } else if (response.data['errors']['phone'] != null) {
        return response.data['errors']['phone'][0];
      } else {
        return AppStrings.errorMessage;
      }
    }else{
      return AppStrings.errorMessage;
    }
  }
}
