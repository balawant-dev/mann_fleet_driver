import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/qrScanSucessModel.dart';

class QrScanRepo {
  final ApiService _api = ApiService();

  Future<QrScanSuccessModel> postQrApi({
    required BuildContext context,
    required String qrToken,
    required String currentStopName,
    required String shiftId,
    required String travelDirection,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.scanQr,
        requiresAuth: true,
        data: {
          "qrToken": qrToken,
          "currentStopName": currentStopName,
          "shiftId": shiftId,
          "travelDirection": travelDirection,
        },
      );
      //   await SecureStorageService.saveToken(response['token']);
      return QrScanSuccessModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Backend error response parse
        return QrScanSuccessModel.fromJson(e.response!.data);
      }

      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => postQrApi(
                context: context,
                currentStopName: currentStopName,
                qrToken: qrToken,
                shiftId: shiftId,
                travelDirection: travelDirection,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => postQrApi(
                context: context,
                currentStopName: currentStopName,
                qrToken: qrToken,
                shiftId: shiftId,
                travelDirection: travelDirection,
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
