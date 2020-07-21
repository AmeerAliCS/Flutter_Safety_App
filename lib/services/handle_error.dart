import 'package:flutter/material.dart';
import 'package:safetyapp/components/alert_dialog.dart';
import 'dart:io';

enum authProblems {
  UserNotFound,
  UserExist,
  PasswordNotValid,
  NetworkError,
  TooManyRequests
}

class ErrorHandler{

  authProblems errorType;

  void handleLoginError(BuildContext context, e) {
    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = authProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = authProblems.NetworkError;
          break;
        case 'We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts. Please try again later. ]' :
          errorType = authProblems.TooManyRequests;
          break;

        default:
          print('Case ${e.message} is not yet implemented');
      }
    } else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          errorType = authProblems.UserNotFound;
          break;
        case 'Error 17009':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'Error 17020':
          errorType = authProblems.NetworkError;
          break;
        case 'ERROR_TOO_MANY_REQUESTS' :
          errorType = authProblems.TooManyRequests;
          break;

        default:
          print('Case ${e.message} is not yet implemented');
      }
    }
    if(errorType == authProblems.PasswordNotValid){
      alertDialog(context: context,title: 'كلمة السر غير صحيحة', description: 'يرجى ادخال كلمة سر صحيحة');
    }
    else if(errorType == authProblems.UserNotFound){
      alertDialog(context: context,title: 'المستخدم غير موجود', description: 'يرجى ادخال معلومات صحيحة');
    }
    else if(errorType == authProblems.NetworkError){
      alertDialog(context: context,title: 'خطأ في الشبكة', description: 'يرجى التحقق من اتصالك بالانترنت');
    }
    else if(errorType == authProblems.TooManyRequests){
      alertDialog(context: context,title: 'لقد حاولت كثيراً', description: 'الرجاء المحاولة لاحقاً');
    }
  }

  void handleRegisterError(BuildContext context , e) {
    if(Platform.isAndroid){
      switch(e.message){
        case 'The email address is already in use by another account.':
          errorType = authProblems.UserExist;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.' :
          errorType = authProblems.NetworkError;
          break;
      }
    }
    else if(Platform.isIOS){
      switch(e.code){
        case 'ERROR_EMAIL_ALREADY_IN_USE' :
          errorType = authProblems.UserExist;
          break;

        case 'Error 17020' :
          errorType = authProblems.NetworkError;
          break;
      }
    }

    if(errorType == authProblems.UserExist){
      alertDialog(context: context,title: 'المستخدم موجود', description: 'المستخدم موجود بالفعل يرجى التسجيل بحساب مختلف');
    }
    else if(errorType == authProblems.NetworkError){
      alertDialog(context: context,title: 'خطأ في الشبكة', description: 'يرجى التحقق من اتصالك بالانترنت');
    }
  }

}