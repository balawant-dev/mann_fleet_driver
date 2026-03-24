import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../../auth/register/model/registerModel.dart';
import '../model/bookingAcceptedModel.dart';
import '../model/bookingCancelModel.dart';
import '../model/newBookingModel.dart';
import '../model/startTripModel.dart';
import '../model/verifyBookingOtpModel.dart';


class NewBookingRepo {
  final ApiService _api = ApiService();




  Future<NewBookingModel> getNewBooking({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.getMyAssignedBookings, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return NewBookingModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getNewBooking(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getNewBooking(context: context),
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
  }  Future<BookingCancelModel> driverCancelRequest({required BuildContext context,required String id,required String reason}) async {
    try {
      final response = await _api.post("${ApiConstants.driverCancelRequest}/${id}", requiresAuth: true,data: {"reason":reason});
      //   await SecureStorageService.saveToken(response['token']);
      return BookingCancelModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => driverCancelRequest(context: context,id: id,reason: reason),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => driverCancelRequest(context: context,reason: reason,id: id),
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

  Future<BookingAcceptedModel> acceptBookingApi({required BuildContext context,required String id}) async {
    try {
      final response = await _api.get("${ApiConstants.acceptBooking}/${id}", requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return BookingAcceptedModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => acceptBookingApi(context: context,id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => acceptBookingApi(context: context,id: id),
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

  Future<StartTripModel> startTripApi({required BuildContext context,required String id}) async {
    try {
      final response = await _api.get("${ApiConstants.startTrip}/${id}", requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return StartTripModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => acceptBookingApi(context: context,id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => acceptBookingApi(context: context,id: id),
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
  Future<VerifyBookingOtpModel> verifyBookingOtpApi({required BuildContext context,required String id,required String otp,required String type}) async {
    try {
      final response = await _api.post("${ApiConstants.verifyBookingOtp}/${id}", requiresAuth: true,data: {
        "otp":otp,
        "type":type//type value ["start", "end"]'
      });
      //   await SecureStorageService.saveToken(response['token']);
      return VerifyBookingOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => acceptBookingApi(context: context,id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => acceptBookingApi(context: context,id: id),
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
