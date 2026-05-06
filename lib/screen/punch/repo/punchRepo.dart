import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/getPunchHistoryModel.dart';
import '../model/getPunchRegionsModel.dart';
import '../model/getPunchStatusModel.dart';
import '../model/punchInModel.dart';
import '../model/punchOutModel.dart';



class PunchRepo {
  final ApiService _api = ApiService();



  Future<GetPunchRegionsModel> getPunchMyPunchRegionApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.punchMyPunchRegion, requiresAuth: true);

      return GetPunchRegionsModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getPunchMyPunchRegionApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getPunchMyPunchRegionApi(context: context),
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

  Future<PunchStatusModel> getPunchStatusApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.punchStatus, requiresAuth: true);

      return PunchStatusModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getPunchStatusApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getPunchStatusApi(context: context),
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

  Future<PunchInModel> postPunchInApi({
    required BuildContext context,
    required String lat,
    required String lng,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.punchIn,
        requiresAuth: true,
        data: {"lat": lat, "lng": lng},
      );

      return PunchInModel.fromJson(response);
    }
    on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return PunchInModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }

      // Existing error handling
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => postPunchInApi(context: context, lat: lat, lng: lng));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => postPunchInApi(context: context, lat: lat, lng: lng));
        throw ServerException();
      } else if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      }
      rethrow;
    }
    catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<PunchOutModel> postPunchOutApi({required BuildContext context,required String lat,required String lng}) async {
    try {
      final response = await _api.post(ApiConstants.punchOut, requiresAuth: true,data: {
      "lat":lat,
      "lng":lng
      //   "lat":"28.529632672319185",
      // "lng":"77.27463003544605"

      });

      return PunchOutModel.fromJson(response);

    } on DioException catch (e) {
      if (e.response != null) {
        try {
          return PunchOutModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => postPunchOutApi(context: context,lat: lat,lng: lng),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => postPunchOutApi(context: context,lat: lat,lng: lng),
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
  }  Future<GetPunchHistoryModel> getPunchHistoryApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.punchHistory, requiresAuth: true);

      return GetPunchHistoryModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getPunchHistoryApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getPunchHistoryApi(context: context),
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
