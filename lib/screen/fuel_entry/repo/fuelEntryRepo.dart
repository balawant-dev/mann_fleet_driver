import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';

import '../model/fetchedFuelLogModel.dart';
import '../model/fuelEntryModel.dart';

class FuelEntryRepo {
  final ApiService _api = ApiService();
  Future<FuelEntryModel> fuelEntryAPi({
    required String carNumber,
    required String paymentSource,
    required bool isTankFull,
    required String fuelType,
    required String locationAddress,
    required String locationLat,
    required String locationLng,
    required String odometerReading,
    required String fuelQuantity,
    required String fuelAmount,
    required String fuelPrice,
    required String invoiceNumber,
    required String odometerMeterImage,
    required String startFuelMeterImage,
    required String endFuelMeterImage,
    required String billImage,
    required BuildContext context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "carNumber": carNumber,
        "isTankFull": isTankFull,
        "paymentSource": paymentSource,
        "fuelType": fuelType,

        "locationAddress": locationAddress,
        "locationLat": locationLat,
        // "licenseNumber": licenseNumber,
        "locationLng": locationLng,
        "odometerReading": odometerReading,
        "fuelQuantity": fuelQuantity,
        "fuelAmount": fuelAmount,
        "fuelPrice": fuelPrice,
        "invoiceNumber": invoiceNumber,

        // ✅ Correct Image Upload
        if (odometerMeterImage.isNotEmpty)
          "odometerMeterImage": await MultipartFile.fromFile(
            odometerMeterImage,
            filename: odometerMeterImage.split('/').last,
          ),

        if (startFuelMeterImage.isNotEmpty)
          "startFuelMeterImage": await MultipartFile.fromFile(
            startFuelMeterImage,
            filename: startFuelMeterImage.split('/').last,
          ),
        if (endFuelMeterImage.isNotEmpty)
          "endFuelMeterImage": await MultipartFile.fromFile(
            endFuelMeterImage,
            filename: endFuelMeterImage.split('/').last,
          ),
        if (billImage.isNotEmpty)
          "billImage": await MultipartFile.fromFile(
            billImage,
            filename: billImage.split('/').last,
          ),
      });

      final response = await _api.postMultipart(
        ApiConstants.fuelLogs,
        data: formData,
        requiresAuth: true,
        isMultipart: true,
      );

      return FuelEntryModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return FuelEntryModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }

      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => fuelEntryAPi(
                context: context,
                isTankFull:isTankFull,
                paymentSource:paymentSource,
                invoiceNumber: invoiceNumber,
                fuelType: fuelType,
                carNumber: carNumber,
                billImage: billImage,
                endFuelMeterImage: endFuelMeterImage,
                fuelAmount: fuelAmount,
                fuelPrice: fuelPrice,
                fuelQuantity: fuelQuantity,
                locationAddress: locationAddress,
                locationLat: locationLat,
                locationLng: locationLng,
                odometerMeterImage: odometerReading,
                odometerReading: odometerReading,
                startFuelMeterImage: startFuelMeterImage,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => fuelEntryAPi(
                isTankFull:isTankFull,
                paymentSource:paymentSource,
                context: context,
                fuelType: fuelType,
                carNumber: carNumber,
                invoiceNumber: invoiceNumber,
                billImage: billImage,
                endFuelMeterImage: endFuelMeterImage,
                fuelAmount: fuelAmount,
                fuelPrice: fuelPrice,
                fuelQuantity: fuelQuantity,
                locationAddress: locationAddress,
                locationLat: locationLat,
                locationLng: locationLng,
                odometerMeterImage: odometerReading,
                odometerReading: odometerReading,
                startFuelMeterImage: startFuelMeterImage,
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

  Future<FetchedFuelLogModel> getFuelLogApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.fuelLogs, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return FetchedFuelLogModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getFuelLogApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getFuelLogApi(context: context),
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
