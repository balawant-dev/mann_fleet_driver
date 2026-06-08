import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../../auth/register/model/registerModel.dart';

import '../../bookingDetail/model/bookingDetailModel.dart';
import '../model/bookingAcceptedModel.dart';
import '../model/bookingCancelModel.dart';
import '../model/extra_charges_payment_model.dart';
import '../model/final_fare_preview_model.dart';
import '../model/getBannerModel.dart';
import '../model/newBookingModel.dart';
import '../model/pickupVerificationModel.dart';
import '../model/startTripModel.dart';
import '../model/tripCompleteModel.dart';
import '../model/updateLocationModel.dart';
import '../model/verifyBookingOtpModel.dart';

class NewBookingRepo {
  final ApiService _api = ApiService();

  Future<GetBannerModel> getBannerApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.banner, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return GetBannerModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getBannerApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getBannerApi(context: context),
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

  Future<NewBookingModel> getNewBooking({required BuildContext context}) async {
    try {
      final response = await _api.get(
        ApiConstants.getMyAssignedBookings,
        requiresAuth: true,
      );
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
  }

  Future<BookingCancelModel> driverCancelRequest({
    required BuildContext context,
    required String id,
    required String reason,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.driverCancelRequest}/${id}",
        requiresAuth: true,
        data: {"reason": reason},
      );
      //   await SecureStorageService.saveToken(response['token']);
      return BookingCancelModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () =>
                  driverCancelRequest(context: context, id: id, reason: reason),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () =>
                  driverCancelRequest(context: context, reason: reason, id: id),
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

  Future<BookingAcceptedModel> acceptBookingApi({
    required BuildContext context,
    required String id,
    required double currentLat,
    required double currentLng,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.acceptBooking}/$id?currentLat=$currentLat&currentLng =$currentLng",
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return BookingAcceptedModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => acceptBookingApi(
                context: context,
                id: id,
                currentLng: currentLng,
                currentLat: currentLat,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => acceptBookingApi(
                context: context,
                id: id,
                currentLng: currentLng,
                currentLat: currentLat,
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

  Future<TripCompleteModel> completeTripApi({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.completeTrip}/${id}",
        requiresAuth: true,
        data: {"currentLat": currentLat, "currentLng": currentLng},
      );
      //   await SecureStorageService.saveToken(response['token']);
      return TripCompleteModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => completeTripApi(
                context: context,
                id: id,
                currentLat: currentLat,
                currentLng: currentLng,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => completeTripApi(
                context: context,
                id: id,
                currentLat: currentLat,
                currentLng: currentLng,
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

  Future<TripExtraPaymentResponse> payFinalFare({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
    required String durationMins,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.finalFare}/$id",
        requiresAuth: true,
        data: {
          "currentLat": currentLat,
          "currentLng": currentLng,
          "durationMins": durationMins,
        },
      );
      return TripExtraPaymentResponse.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => completeTripApi(
                context: context,
                id: id,
                currentLat: currentLat,
                currentLng: currentLng,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => completeTripApi(
                context: context,
                id: id,
                currentLat: currentLat,
                currentLng: currentLng,
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

  Future<bool> extraPaymentCash({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.extraPaymentCash}/$id",
        data: {"currentLat": currentLat, "currentLng": currentLng},
        requiresAuth: true,
      );
      return response['status'];
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<bool> waiveExtraPayment({
    required BuildContext context,
    required String id,
    required String reason,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.waiveExtraPayment}/$id",
        requiresAuth: true,
        data: {"reason": reason},
      );
      return response['status'];
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<FinalFarePreviewModel> checkFinalFare({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
    required String durationMins,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.checkFinalFare}/$id",
        requiresAuth: true,
        data: {
          "currentLat": currentLat,
          "currentLng": currentLng,
          "durationMins": durationMins,
        },
      );
      return FinalFarePreviewModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => checkFinalFare(
                context: context,
                id: id,
                currentLat: currentLat,
                currentLng: currentLng,
                durationMins: durationMins,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => checkFinalFare(
                context: context,
                id: id,
                currentLat: currentLat,
                currentLng: currentLng,
                durationMins: durationMins,
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

  Future<String> extraPaymentStatus({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.extraPaymentStatus}/$id",
        requiresAuth: true,
      );
      return response['data']['extraPayment']['status'];
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => extraPaymentStatus(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => extraPaymentStatus(context: context, id: id),
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

  Future<bool> checkDriverPickupRange({
    required BuildContext context,
    required String id,
    required double currentLat,
    required double currentLng,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.checkDriverPickupRange}/$id",
        data: {"currentLat": currentLat, "currentLng": currentLng},
        requiresAuth: true,
      );
      return response['data']['isInRange'];
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<bool> driverArrived({
    required BuildContext context,
    required String id,
    required double currentLat,
    required double currentLng,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.driverArrived}/$id",
        data: {"currentLat": currentLat, "currentLng": currentLng},
        requiresAuth: true,
      );
      return response['status'];
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => startTripApi(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => startTripApi(context: context, id: id),
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

  Future<StartTripModel> startTripApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.startTrip}/${id}",
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return StartTripModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => startTripApi(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => startTripApi(context: context, id: id),
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

  Future<VerifyBookingOtpModel> verifyBookingOtpApi({
    required BuildContext context,
    required String id,
    required String otp,
    required String type,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.verifyBookingOtp}/${id}",
        requiresAuth: true,
        data: {
          "otp": otp,
          "type": type, //type value ["start", "end"]'
        },
      );
      //   await SecureStorageService.saveToken(response['token']);
      return VerifyBookingOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => verifyBookingOtpApi(
                context: context,
                id: id,
                type: type,
                otp: otp,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => verifyBookingOtpApi(
                context: context,
                id: id,
                otp: otp,
                type: type,
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

  Future<BookingDetailModel> getBookingDetailApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.bookingDetail}/${id}",
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return BookingDetailModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getBookingDetailApi(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getBookingDetailApi(context: context, id: id),
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

  Future<UpdateLocationModel> updateDriverLocationApi({
    required BuildContext context,
    required String id,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _api.patch(
        "${ApiConstants.updateDriverLocation}/${id}",
        requiresAuth: true,
        data: {"lat": lat, "lng": lng},
      );
      //   await SecureStorageService.saveToken(response['token']);
      return UpdateLocationModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => updateDriverLocationApi(
                context: context,
                id: id,
                lat: lat,
                lng: lng,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => updateDriverLocationApi(
                context: context,
                id: id,
                lng: lng,
                lat: lat,
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

  Future<PickupVerificationModel> pickupVerificationApi({
    required String id,

    required String frontViewImage,
    required String backViewImage,
    required String leftViewImage,
    required String rightViewImage,
    required String interiorImage,
    required String speedometerImage,
    required String speedoMetervalue,
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
          ),
        if (speedometerImage.isNotEmpty)
          "speedometerImage": await MultipartFile.fromFile(
            speedometerImage,
            filename: speedometerImage.split('/').last,
          ),
        "speedoMetervalue": speedoMetervalue,
      });

      final response = await _api.postMultipart(
        "${ApiConstants.pickupVerification}/$id",
        data: formData,
        requiresAuth: true,
        isMultipart: true,
      );

      return PickupVerificationModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => pickupVerificationApi(
                id: id,
                context: context,
                backViewImage: backViewImage,
                frontViewImage: frontViewImage,
                interiorImage: interiorImage,
                leftViewImage: leftViewImage,
                rightViewImage: rightViewImage,
                speedometerImage: speedometerImage,
                speedoMetervalue: speedoMetervalue,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => pickupVerificationApi(
                id: id,
                context: context,
                backViewImage: backViewImage,
                frontViewImage: frontViewImage,
                interiorImage: interiorImage,
                leftViewImage: leftViewImage,
                rightViewImage: rightViewImage,
                speedometerImage: speedometerImage,
                speedoMetervalue: speedoMetervalue,
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

  Future<PickupVerificationModel> speedometerVerification({
    required String id,
    required String speedometerImage,
    required String speedoMetervalue,
    required BuildContext context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        // "name": name,
        if (speedometerImage.isNotEmpty)
          "image": await MultipartFile.fromFile(
            speedometerImage,
            filename: speedometerImage.split('/').last,
          ),
        if (speedoMetervalue.isNotEmpty)
          "speedoMetervalueEnd": speedoMetervalue,
      });

      print(formData.fields.first.value);
      print(formData.fields.first.key);
      print(formData.files.first.key);
      print(formData.files.first.value);
      final response = await _api.patchMultipart(
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
          onRetry:
              () => speedometerVerification(
                id: id,
                context: context,
                speedoMetervalue: speedoMetervalue,
                speedometerImage: speedometerImage,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => speedometerVerification(
                id: id,
                context: context,
                speedoMetervalue: speedoMetervalue,
                speedometerImage: speedometerImage,
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
