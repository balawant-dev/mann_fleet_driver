import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/resendOtpModel.dart';
import '../model/verifyOtpModel.dart';

class VerifyOtpRepo{
  final ApiService _api = ApiService();

  Future<VerifyOtpModel> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken ,
    required String deviceID ,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.verifyOtp,
        data: {'phone': phone,"otp":otp,"fcmToken":fcmToken ,"deviceId":deviceID},
        requiresAuth: false,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return VerifyOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => verifyOtp(phone: phone, otp: otp,context: context,fcmToken: fcmToken,deviceID: deviceID),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => verifyOtp(phone: phone, otp: otp,context: context,fcmToken: fcmToken,deviceID: deviceID),
        );
        throw ServerException();
      } else if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }  Future<ResendOtpModel> resendOtpApi({
    required String phone,

    required BuildContext context,
  }) async {
    try {
      //"countryCode":"+91"
      final response = await _api.post(
        ApiConstants.signUp,
        data: {'phone': phone,},
        requiresAuth: false,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return ResendOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => resendOtpApi(phone: phone, context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => resendOtpApi(phone: phone, context: context),
        );
        throw ServerException();
      } else if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }
}