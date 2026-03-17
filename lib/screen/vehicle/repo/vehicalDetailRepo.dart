




import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';

import '../model/editVehicleDetailModel.dart';
import '../model/getSegmentsModel.dart';

import '../model/getVehicleModel.dart';
import '../model/vehicalDetailModel.dart';

class VehicalDetailRepo {
  final ApiService _api = ApiService();
  Future<VehicleDetailCreateModel> vehicleAddApi({
    required String segment,
    required String brand,
    required String model,
    required String fuelType,
    required String year,
    required String color,

    required String carNumber,
    required String bootSpace,
    required String certificateNumber,
    required String certificateExpiry,
    required String insuranceExpiry,
    required String pollutionExpiry,
    required String rcExpeiry,
    required String capacity,
    required String carImage,
    required String documentImage,
    required String certificatePhoto,
    required String rcFrontPhoto,
    required String rcBackPhoto,
    required BuildContext context,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        "segment": segment,//ye suggent ID jayega get api se ok
        "brand": brand,
        "model": model,
        "fuelType": fuelType,
        "year": year,
        "color": color,
        "carNumber": carNumber,
        "bootSpace": bootSpace,
        "certificateNumber": certificateNumber,
        "certificateExpiry": certificateExpiry,
        "insuranceExpiry": insuranceExpiry,
        "pollutionExpiry": pollutionExpiry,
        "rcExpeiry": rcExpeiry,
        "capacity": capacity,


        "carImage": await MultipartFile.fromFile(  //      { name: "carImage", maxCount: 6 },
          carImage,
          filename: carImage.split('/').last,
        ),
        "documentImage": await MultipartFile.fromFile(  //      { name: "documentImage", maxCount: 10 },
          documentImage,
          filename: documentImage.split('/').last,
        ),
        "certificatePhoto": await MultipartFile.fromFile(  //      { name: "certificatePhoto", maxCount: 10 },
          certificatePhoto,
          filename: certificatePhoto.split('/').last,
        ),
        "rcFrontPhoto": await MultipartFile.fromFile(  //      { name: "rcFrontPhoto", maxCount: 10 },
          rcFrontPhoto,
          filename: rcFrontPhoto.split('/').last,
        ),     "rcBackPhoto": await MultipartFile.fromFile(  //      { name: "rcBackPhoto", maxCount: 10 },
          rcBackPhoto,
          filename: rcBackPhoto.split('/').last,
        ),
      });
      print(".......................Start...........................");
      formData.fields.forEach((field) {
        print("FIELD => ${field.key} : ${field.value}");
      });

      formData.files.forEach((file) {
        print("FILE => ${file.key} : ${file.value.filename}");
      });   print("......................End............................");
      final response = await _api.postMultipart(
        ApiConstants.vehicle,
        data: formData, // 👈 important
        requiresAuth: true,
        isMultipart: true,
      );

      return VehicleDetailCreateModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => vehicleAddApi(
            segment: segment,
            context: context,
     color: color,
            bootSpace: bootSpace,
            brand: brand,
            capacity: capacity,
            certificateExpiry: certificateExpiry,
            carImage: carImage,
            certificateNumber: certificateNumber,
            certificatePhoto: certificatePhoto,
            carNumber: carNumber,
            documentImage: documentImage,fuelType: fuelType,
            insuranceExpiry: insuranceExpiry,
            model: model,
            pollutionExpiry: pollutionExpiry,
            rcBackPhoto: rcBackPhoto,
            rcExpeiry: rcExpeiry,
            rcFrontPhoto: rcFrontPhoto,
            year: year


          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => vehicleAddApi(
              segment: segment,
              context: context,
              color: color,
              bootSpace: bootSpace,
              brand: brand,
              capacity: capacity,
              certificateExpiry: certificateExpiry,
              carImage: carImage,
              certificateNumber: certificateNumber,
              certificatePhoto: certificatePhoto,
              carNumber: carNumber,
              documentImage: documentImage,fuelType: fuelType,
              insuranceExpiry: insuranceExpiry,
              model: model,
              pollutionExpiry: pollutionExpiry,
              rcBackPhoto: rcBackPhoto,
              rcExpeiry: rcExpeiry,
              rcFrontPhoto: rcFrontPhoto,
              year: year
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
  Future<EditVehicleDetailModel> vehicleEditApi({
    required String segment,
    required String brand,
    required String model,
    required String fuelType,
    required String year,
    required String color,

    required String carNumber,
    required String bootSpace,
    required String certificateNumber,
    required String certificateExpiry,
    required String insuranceExpiry,
    required String pollutionExpiry,
    required String rcExpeiry,
    required String capacity,
    required String carImage,
    required String documentImage,
    required String certificatePhoto,
    required String rcFrontPhoto,
    required String rcBackPhoto,
    required BuildContext context,
  }) async {
    try {

      // FormData formData = FormData.fromMap({
      //   "segment": segment,//ye suggent ID jayega get api se ok
      //   "brand": brand,
      //   "model": model,
      //   "fuelType": fuelType,
      //   "year": year,
      //   "color": color,
      //   "carNumber": carNumber,
      //   "bootSpace": bootSpace,
      //   "certificateNumber": certificateNumber,
      //   "certificateExpiry": certificateExpiry,
      //   "insuranceExpiry": insuranceExpiry,
      //   "pollutionExpiry": pollutionExpiry,
      //   "rcExpeiry": rcExpeiry,
      //   "capacity": capacity,
      //
      //
      //   "carImage": await MultipartFile.fromFile(  //      { name: "carImage", maxCount: 6 },
      //     carImage,
      //     filename: carImage.split('/').last,
      //   ),
      //   "documentImage": await MultipartFile.fromFile(  //      { name: "documentImage", maxCount: 10 },
      //     documentImage,
      //     filename: documentImage.split('/').last,
      //   ),
      //   "certificatePhoto": await MultipartFile.fromFile(  //      { name: "certificatePhoto", maxCount: 10 },
      //     certificatePhoto,
      //     filename: certificatePhoto.split('/').last,
      //   ),
      //   "rcFrontPhoto": await MultipartFile.fromFile(  //      { name: "rcFrontPhoto", maxCount: 10 },
      //     rcFrontPhoto,
      //     filename: rcFrontPhoto.split('/').last,
      //   ),     "rcBackPhoto": await MultipartFile.fromFile(  //      { name: "rcBackPhoto", maxCount: 10 },
      //     rcBackPhoto,
      //     filename: rcBackPhoto.split('/').last,
      //   ),
      // });
      FormData formData = FormData.fromMap({
        "segment": segment,
        "brand": brand,
        "model": model,
        "fuelType": fuelType,
        "year": year,
        "color": color,
        "carNumber": carNumber,
        "bootSpace": bootSpace,
        "certificateNumber": certificateNumber,
        "certificateExpiry": certificateExpiry,
        "insuranceExpiry": insuranceExpiry,
        "pollutionExpiry": pollutionExpiry,
        "rcExpeiry": rcExpeiry,
        "capacity": capacity,
      });
      if (carImage.isNotEmpty) {
        formData.files.add(MapEntry(
          "carImage",
          await MultipartFile.fromFile(carImage, filename: carImage.split('/').last),
        ));
      }

      if (documentImage.isNotEmpty) {
        formData.files.add(MapEntry(
          "documentImage",
          await MultipartFile.fromFile(documentImage, filename: documentImage.split('/').last),
        ));
      }

      if (certificatePhoto.isNotEmpty) {
        formData.files.add(MapEntry(
          "certificatePhoto",
          await MultipartFile.fromFile(certificatePhoto, filename: certificatePhoto.split('/').last),
        ));
      }

      if (rcFrontPhoto.isNotEmpty) {
        formData.files.add(MapEntry(
          "rcFrontPhoto",
          await MultipartFile.fromFile(rcFrontPhoto, filename: rcFrontPhoto.split('/').last),
        ));
      }

      if (rcBackPhoto.isNotEmpty) {
        formData.files.add(MapEntry(
          "rcBackPhoto",
          await MultipartFile.fromFile(rcBackPhoto, filename: rcBackPhoto.split('/').last),
        ));
      }
      print(".......................Start...........................");
      formData.fields.forEach((field) {
        print("FIELD => ${field.key} : ${field.value}");
      });

      formData.files.forEach((file) {
        print("FILE => ${file.key} : ${file.value.filename}");
      });   print("......................End............................");
      final response = await _api.patchMultipart(
        ApiConstants.vehicle,
        data: formData, // 👈 important
        requiresAuth: true,
        isMultipart: true,
      );

      return EditVehicleDetailModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => vehicleEditApi(
            segment: segment,
            context: context,
     color: color,
            bootSpace: bootSpace,
            brand: brand,
            capacity: capacity,
            certificateExpiry: certificateExpiry,
            carImage: carImage,
            certificateNumber: certificateNumber,
            certificatePhoto: certificatePhoto,
            carNumber: carNumber,
            documentImage: documentImage,fuelType: fuelType,
            insuranceExpiry: insuranceExpiry,
            model: model,
            pollutionExpiry: pollutionExpiry,
            rcBackPhoto: rcBackPhoto,
            rcExpeiry: rcExpeiry,
            rcFrontPhoto: rcFrontPhoto,
            year: year

          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => vehicleEditApi(
              segment: segment,
              context: context,
              color: color,
              bootSpace: bootSpace,
              brand: brand,
              capacity: capacity,
              certificateExpiry: certificateExpiry,
              carImage: carImage,
              certificateNumber: certificateNumber,
              certificatePhoto: certificatePhoto,
              carNumber: carNumber,
              documentImage: documentImage,fuelType: fuelType,
              insuranceExpiry: insuranceExpiry,
              model: model,
              pollutionExpiry: pollutionExpiry,
              rcBackPhoto: rcBackPhoto,
              rcExpeiry: rcExpeiry,
              rcFrontPhoto: rcFrontPhoto,
              year: year
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



  Future<GetSegmentsModel> getSegmentApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.segment, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return GetSegmentsModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getSegmentApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getSegmentApi(context: context),
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
  }  Future<GetVehicleModel> getVehicleApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.vehicle, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return GetVehicleModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getSegmentApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getSegmentApi(context: context),
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
