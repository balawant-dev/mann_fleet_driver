import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../../auth/register/model/registerModel.dart';
import '../../myBooking/model/bookingDetailModel.dart';
import '../model/bookingAcceptedModel.dart';
import '../model/bookingCancelModel.dart';
import '../model/newBookingModel.dart';
import '../model/pickupVerificationModel.dart';
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


  Future<BookingDetailModel> getBookingDetailApi({required BuildContext context,required String id}) async {
    try {
      final response = await _api.get("${ApiConstants.bookingDetail}/${id}", requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return BookingDetailModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getBookingDetailApi(context: context,id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getBookingDetailApi(context: context,id: id),
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

  Future<PickupVerificationModel> pickupVerificationApi({
    required String id,

    required String frontViewImage,
    required String backViewImage,
    required String leftViewImage,
    required String rightViewImage,
    required String interiorImage,
    required String speedometerImage,
    required BuildContext context,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        // "name": name,


        if (frontViewImage.isNotEmpty)
          "frontViewImage": await MultipartFile.fromFile(
            frontViewImage,
            filename: frontViewImage.split('/').last,
          ),

        if (backViewImage.isNotEmpty)
          "backViewImage": await MultipartFile.fromFile(
            backViewImage,
            filename: backViewImage.split('/').last,
          ),
        if (leftViewImage.isNotEmpty)
          "leftViewImage": await MultipartFile.fromFile(
            leftViewImage,
            filename: leftViewImage.split('/').last,
          ),
        if (rightViewImage.isNotEmpty)
          "rightViewImage": await MultipartFile.fromFile(
            rightViewImage,
            filename: rightViewImage.split('/').last,
          ),
        if (interiorImage.isNotEmpty)
          "interiorImage": await MultipartFile.fromFile(
            interiorImage,
            filename: interiorImage.split('/').last,
          ), if (speedometerImage.isNotEmpty)
          "speedometerImage": await MultipartFile.fromFile(
            speedometerImage,
            filename: speedometerImage.split('/').last,
          ),

      });

      final response = await _api.postMultipart(
        "${ApiConstants.pickupVerification}/${id}",
        data: formData, // 👈 important
        requiresAuth: true,
        isMultipart: true,
      );

      return PickupVerificationModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => pickupVerificationApi(
            id: id,
            context: context,
          backViewImage: backViewImage,
            frontViewImage: frontViewImage,
            interiorImage: interiorImage,
            leftViewImage: leftViewImage,
            rightViewImage: rightViewImage,
            speedometerImage: speedometerImage
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => pickupVerificationApi(
              id: id,
              context: context,
              backViewImage: backViewImage,
              frontViewImage: frontViewImage,
              interiorImage: interiorImage,
              leftViewImage: leftViewImage,
              rightViewImage: rightViewImage,
              speedometerImage: speedometerImage
          ),
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
