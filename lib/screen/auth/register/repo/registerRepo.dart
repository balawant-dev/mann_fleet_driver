import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/registerModel.dart';
class RegisterRepo{
  final ApiService _api = ApiService();


  Future<RegisterModel> registerApi({
    required String name,
    required String email,
    required String phone,
    required String licenseNumber,
    required String gender,
    required String profilePic, // 👈 path aa raha hai
    required BuildContext context,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "licenseNumber": licenseNumber,
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
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return RegisterModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => registerApi(
            name: name,
            context: context,
            phone: phone,
            email: email,
            licenseNumber: licenseNumber,
            gender: gender,
            profilePic: profilePic,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => registerApi(
            name: name,
            context: context,
            phone: phone,
            email: email,
            licenseNumber: licenseNumber,
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
}