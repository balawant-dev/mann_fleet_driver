import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../../auth/register/model/registerModel.dart';
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
    required String profilePic, // 👈 path aa raha hai
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
        "profilePic": await MultipartFile.fromFile(
          profilePic,
          filename: profilePic.split('/').last,
        ),
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
          onRetry: () => updateBasicDetail(
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
          onRetry: () => updateBasicDetail(
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
}
