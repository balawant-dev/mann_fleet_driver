import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../../auth/register/model/registerModel.dart';
import '../model/aadharVerifyModel.dart';
import '../model/checkMandatoryUpdate.dart';
import '../model/complteAdharVarification.dart';
import '../model/editProfileModel.dart';
import '../model/getProfileModel.dart';

class ProfileRepo {
  final ApiService _api = ApiService();
  Future<RegisterModel> updateBasicDetail({
    required String name,
    required String email,
    required String phone,
    required String permanentAddress,
    required String currentAddress,
    required String gender,
    required String profilePic,
    required BuildContext context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "permanentAddress": permanentAddress,
        "currentAddress": currentAddress,
        // "licenseNumber": licenseNumber,
        "gender": gender,

        // ✅ Correct Image Upload
        if (profilePic.isNotEmpty)
          "profilePic": await MultipartFile.fromFile(
            profilePic,
            filename: profilePic.split('/').last,
          ),
        // "profilePic": await MultipartFile.fromFile(
        //   profilePic,
        //   filename: profilePic.split('/').last,
        // ),
      });

      final response = await _api.patchMultipart(
        ApiConstants.profile,
        data: formData, // 👈 important
        requiresAuth: true,
        isMultipart: true,
      );

      return RegisterModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => updateBasicDetail(
                name: name,
                context: context,
                phone: phone,
                email: email,
                currentAddress: currentAddress,
                permanentAddress: permanentAddress,
                gender: gender,
                profilePic: profilePic,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => updateBasicDetail(
                name: name,
                context: context,
                phone: phone,
                email: email,
                currentAddress: currentAddress,
                permanentAddress: permanentAddress,
                gender: gender,
                profilePic: profilePic,
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

  Future<GetProfileModel> getProfileApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.profile, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return GetProfileModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getProfileApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getProfileApi(context: context),
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

  Future<PlatformDependenciesModel> getPlatformDependenciesApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.platformDependencies,
        requiresAuth: false,
      );

      return PlatformDependenciesModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getPlatformDependenciesApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getPlatformDependenciesApi(context: context),
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

  Future<RegisterModel> updateDrivingCredentials({
    required String licenseNumber,
    required String licenseExpiry,
    required File? licensePhoto,
    required File? licenseBackPhoto,
    required BuildContext context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "licenseNumber": licenseNumber,
        "licenseExpiry": licenseExpiry,

        if (licensePhoto != null)
          "licensePhoto": await MultipartFile.fromFile(
            licensePhoto.path,
            filename: licensePhoto.path.split('/').last,
          ),
        if (licenseBackPhoto != null)
          "licenseBackPhoto": await MultipartFile.fromFile(
            licenseBackPhoto.path,
            filename: licenseBackPhoto.path.split('/').last,
          ),
      });

      final response = await _api.patchMultipart(
        ApiConstants.profile,
        data: formData,
        requiresAuth: true,
        isMultipart: true,
      );

      return RegisterModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<RegisterModel> updateComplianceFull({
    required File? adhaarFront,
    required File? adhaarBack,
    required File? panFront,
    required File? panBack,
    required File? policeVerification,
    required String adhaarNumber,
    required String panNumber,
    required String policeExpiry,
    required BuildContext context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "adhaarNumber": adhaarNumber,
        "panNumber": panNumber,
        "policeVerificationExpiry": policeExpiry,

        if (adhaarFront != null)
          "adhaarFrontPhoto": await MultipartFile.fromFile(
            adhaarFront.path,
            filename: adhaarFront.path.split('/').last,
          ),

        if (adhaarBack != null)
          "adhaarBackPhoto": await MultipartFile.fromFile(
            adhaarBack.path,
            filename: adhaarBack.path.split('/').last,
          ),

        if (panFront != null)
          "panFrontPhoto": await MultipartFile.fromFile(
            panFront.path,
            filename: panFront.path.split('/').last,
          ),

        if (panBack != null)
          "panBackPhoto": await MultipartFile.fromFile(
            panBack.path,
            filename: panBack.path.split('/').last,
          ),

        if (policeVerification != null)
          "policeVerificationPhoto": await MultipartFile.fromFile(
            policeVerification.path,
            filename: policeVerification.path.split('/').last,
          ),
      });

      final response = await _api.patchMultipart(
        ApiConstants.profile,
        data: formData,
        requiresAuth: true,
        isMultipart: true,
      );

      return RegisterModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<AadharVerifyModel> verifyAadhaar({required String adharNumber}) async {
    try {
      final response = await _api.post(
        ApiConstants.verifyAadhaar,
        data: {"adharNumber": adharNumber},
        requiresAuth: true,
      );

      return AadharVerifyModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<AadharVerificationComplteModel> verifyCompleteAadhaar({
    required String adharNumber,
    required String clientId,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.verifyCompleteAadhaar,
        data: {"adharNumber": adharNumber, "clientId": clientId},
        requiresAuth: true,
      );

      return AadharVerificationComplteModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }
}
