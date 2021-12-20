import 'package:flutter/material.dart';
import 'dart:io';

import 'package:student_attendance/components/alert_dialog.dart';

enum authProblems {
  userNotFound,
  userExist,
  passwordNotValid,
  networkError,
  tooManyRequests
}

class ErrorHandler{

  late authProblems errorType;

  void handleLoginError(BuildContext context, e) {
    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = authProblems.userNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = authProblems.passwordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = authProblems.networkError;
          break;
        case 'We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts. Please try again later. ]' :
          errorType = authProblems.tooManyRequests;
          break;

        default:
          print('Case ${e.message} is not yet implemented');
      }
    } else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          errorType = authProblems.userNotFound;
          break;
        case 'Error 17009':
          errorType = authProblems.passwordNotValid;
          break;
        case 'Error 17020':
          errorType = authProblems.networkError;
          break;
        case 'ERROR_TOO_MANY_REQUESTS' :
          errorType = authProblems.tooManyRequests;
          break;

        default:
          print('Case ${e.message} is not yet implemented');
      }
    }
    if(errorType == authProblems.passwordNotValid){
      alertDialog(context: context,title: 'كلمة السر غير صحيحة', description: 'يرجى ادخال كلمة سر صحيحة');
    }
    else if(errorType == authProblems.userNotFound){
      alertDialog(context: context,title: 'المستخدم غير موجود', description: 'يرجى ادخال معلومات صحيحة');
    }
    else if(errorType == authProblems.networkError){
      alertDialog(context: context,title: 'خطأ في الشبكة', description: 'يرجى التحقق من اتصالك بالانترنت');
    }
    else if(errorType == authProblems.tooManyRequests){
      alertDialog(context: context,title: 'لقد حاولت كثيراً', description: 'الرجاء المحاولة لاحقاً');
    }
  }

  void handleRegisterError(BuildContext context , e) {
    if(Platform.isAndroid){
      switch(e.message){
        case 'The email address is already in use by another account.':
          errorType = authProblems.userExist;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.' :
          errorType = authProblems.networkError;
          break;
      }
    }
    else if(Platform.isIOS){
      switch(e.code){
        case 'ERROR_EMAIL_ALREADY_IN_USE' :
          errorType = authProblems.userExist;
          break;

        case 'Error 17020' :
          errorType = authProblems.networkError;
          break;
      }
    }

    if(errorType == authProblems.userExist){
      alertDialog(context: context,title: 'المستخدم موجود', description: 'المستخدم موجود بالفعل يرجى التسجيل بحساب مختلف');
    }
    else if(errorType == authProblems.networkError){
      alertDialog(context: context,title: 'خطأ في الشبكة', description: 'يرجى التحقق من اتصالك بالانترنت');
    }
  }

}