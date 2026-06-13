import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/fetchedShiftBookingsModel.dart';
import '../model/shuttleShiftDetailModel.dart';
import '../model/shuttleShiftModel.dart';

class ShuttleShiftRepo {
  final ApiService _api = ApiService();

  Future<ShuttleShiftModel> shuttleShiftApi({
    required BuildContext context,

  }) async {
    try {
      final response = await _api.get(
        ApiConstants.shuttleShift,
        requiresAuth: true,

      );
      //   await SecureStorageService.saveToken(response['token']);
      return ShuttleShiftModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Backend error response parse
        return ShuttleShiftModel.fromJson(e.response!.data);
      }

      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => shuttleShiftApi(
                context: context,

              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => shuttleShiftApi(
                context: context,

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


  Future<ShuttleShiftDetailModel> shuttleShiftDetailApi({
    required BuildContext context,
    required String id,

  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.shuttleShift}/$id",
        requiresAuth: true,

      );
      //   await SecureStorageService.saveToken(response['token']);
      return ShuttleShiftDetailModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Backend error response parse
        return ShuttleShiftDetailModel.fromJson(e.response!.data);
      }

      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => shuttleShiftDetailApi(
                context: context,
                id: id

              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => shuttleShiftDetailApi(
                context: context,
                id: id

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
  }  Future<FetchedShiftBookingsModel> fetchedShiftBookingsApi({
    required BuildContext context,
    required String id,

  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.shuttleBookings}/$id",
        requiresAuth: true,

      );
      //   await SecureStorageService.saveToken(response['token']);
      return FetchedShiftBookingsModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Backend error response parse
        return FetchedShiftBookingsModel.fromJson(e.response!.data);
      }

      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => fetchedShiftBookingsApi(
                context: context,
                id: id

              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => fetchedShiftBookingsApi(
                context: context,         id: id

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
