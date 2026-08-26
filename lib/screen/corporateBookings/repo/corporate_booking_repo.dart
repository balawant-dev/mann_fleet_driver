import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/corporate_booking_history_model.dart';
import '../model/corporate_booking_list_model.dart';
import '../model/corporate_booking_detail_model.dart';

class CorporateBookingRepo {
  final ApiService _api = ApiService();

  Future<CorporateBookingHistoryResponse> getCorporateBookingsHistory({
    required BuildContext context,
    int page = 1,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.corporateBookings}/history",
        requiresAuth: true,
        // queryParameters: {'page': page}, // if backend supports pagination
      );
      return CorporateBookingHistoryResponse.fromJson(response);
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getCorporateBookings(context: context, page: page),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCorporateBookings(context: context, page: page),
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
  }  Future<CorporateBookingListModel> getCorporateBookings({
    required BuildContext context,
    int page = 1,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.corporateBookings,
        requiresAuth: true,
        // queryParameters: {'page': page}, // if backend supports pagination
      );
      return CorporateBookingListModel.fromJson(response);
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getCorporateBookings(context: context, page: page),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCorporateBookings(context: context, page: page),
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

  Future<CorporateBookingDetailModel> getCorporateBookingDetail({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.corporateBookings}/$id",
        requiresAuth: true,
      );
      return CorporateBookingDetailModel.fromJson(response);
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getCorporateBookingDetail(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCorporateBookingDetail(context: context, id: id),
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

  // Accept / Reject (adjust endpoint if your backend is different)
  Future<bool> acceptToBooking({
    required BuildContext context,
    required String bookingId,
    required double currentLat, // "accepted" or "rejected"
    required double currentLng , // "accepted" or "rejected"
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/accept",
        data: {"currentLat": currentLat,"currentLng":currentLng},
        requiresAuth: true,
      );
      // return response['status'] == true;
     return response['status'] == true;

    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => acceptToBooking(
            context: context,
            bookingId: bookingId,
            currentLat: currentLat,
            currentLng: currentLng
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => acceptToBooking(
            context: context,
            bookingId: bookingId,
              currentLat: currentLat,
              currentLng: currentLng
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



  Future<bool> respondToBooking({
    required BuildContext context,
    required String bookingId,
    required String status, // "accepted" or "rejected"
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/respond",
        data: {"status": status},
        requiresAuth: true,
      );
     return response['status'] == true;
      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => respondToBooking(
            context: context,
            bookingId: bookingId,
            status: status,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => respondToBooking(
            context: context,
            bookingId: bookingId,
            status: status,
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

  Future<bool> extraChargeApi({
    required BuildContext context,
    required String bookingId,
    required String parkingCharge,
    required String tollAmount,
    required String stateCharge,
    required String otherCharges ,
  }) async {
    try {
      final response = await _api.patch(
        "${ApiConstants.corporateBookings}/$bookingId/extra-charges",
        data: {"parkingCharge": parkingCharge,"tollAmount":tollAmount,"stateCharge":stateCharge,"otherCharges":otherCharges},
        requiresAuth: true,
      );
     return response['status'] == true;
      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => extraChargeApi(
            context: context,
            bookingId: bookingId,
          tollAmount: tollAmount,
            otherCharges: otherCharges,parkingCharge: parkingCharge,stateCharge: stateCharge
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => extraChargeApi(
              context: context,
              bookingId: bookingId,
              tollAmount: tollAmount,
              otherCharges: otherCharges,parkingCharge: parkingCharge,stateCharge: stateCharge
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
  }  Future<bool> completeTripApi({
    required BuildContext context,
    required String bookingId,

  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/complete",

        requiresAuth: true,
      );
     return response['status'] == true;
      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => completeTripApi(
            context: context,
            bookingId: bookingId,

          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => completeTripApi(
              context: context,
              bookingId: bookingId,

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




  Future<bool> garageStart({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        "odometer": odometer,
        "currentLat": currentLat,
        "currentLng": currentLng,
        "odometerImage": await MultipartFile.fromFile(
          odometerImage.path,
          filename: odometerImage.path.split('/').last,
        ),
      });

      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/garage-start",
        data: formData,
        requiresAuth: true,
        // Important: ApiService should set Content-Type to multipart automatically when FormData is passed
      );
     return response['status'] == true;

      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => garageStart(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => garageStart(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
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



  Future<bool> pickupCheckpoint({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        "odometer": odometer,
        "currentLat": currentLat,
        "currentLng": currentLng,
        "odometerImage": await MultipartFile.fromFile(
          odometerImage.path,
          filename: odometerImage.path.split('/').last,
        ),
      });

      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/pickup-checkpoint",
        data: formData,
        requiresAuth: true,
        // Important: ApiService should set Content-Type to multipart automatically when FormData is passed
      );
     return response['status'] == true;

      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => pickupCheckpoint(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => pickupCheckpoint(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
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




  Future<bool> dropCheckpoint({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        "odometer": odometer,
        "currentLat": currentLat,
        "currentLng": currentLng,
        "odometerImage": await MultipartFile.fromFile(
          odometerImage.path,
          filename: odometerImage.path.split('/').last,
        ),
      });

      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/drop-checkpoint",
        data: formData,
        requiresAuth: true,
        // Important: ApiService should set Content-Type to multipart automatically when FormData is passed
      );if (response['status'] == true) {
        return true;
      } else {
        // Prefer error.message, fallback to message
        final errorMsg = response['error']?['message'] ??
            response['message'] ??
            'Something went wrong';
        throw ApiException(
          response['error']?['statusCode'] ?? 400,
          errorMsg,
        );
      }

      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => dropCheckpoint(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => dropCheckpoint(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
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
  Future<bool> garageEndApi({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        "odometer": odometer,
        "currentLat": currentLat,
        "currentLng": currentLng,
        "odometerImage": await MultipartFile.fromFile(
          odometerImage.path,
          filename: odometerImage.path.split('/').last,
        ),
      });

      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/garage-end",
        data: formData,
        requiresAuth: true,
        // Important: ApiService should set Content-Type to multipart automatically when FormData is passed
      );
     return response['status'] == true;

      // return response['status'] == true;
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => garageEndApi(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => garageEndApi(
            context: context,
            bookingId: bookingId,
            odometer: odometer,
            currentLat: currentLat,
            currentLng: currentLng,
            odometerImage: odometerImage,
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






    Future<bool> startRide({
    required BuildContext context,
    required String bookingId,

  }) async {
    try {


      final response = await _api.post(
        "${ApiConstants.corporateBookings}/$bookingId/start",
        // data: formData,
        requiresAuth: true,

      );
     return response['status'] == true;

      // return response['status'] == true;
    } on DioException catch (e) {
      
      String errorMsg = 'Something went wrong';

  if (e.response?.data != null) {
    final data = e.response!.data;
    if (data is Map) {
      errorMsg = data['error']?['message'] ??
          data['message'] ??
          errorMsg;
    }
  }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => startRide(
            context: context,
            bookingId: bookingId,

          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => startRide(
            context: context,
            bookingId: bookingId,

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