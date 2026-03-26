import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../../auth/register/model/registerModel.dart';
import '../model/bookingDetailModel.dart';


class BookingDetailRepo {
  final ApiService _api = ApiService();




  Future<BookingDetailModel> getBookingDetailApi({required BuildContext context,required String id}) async {
    try {
      final response = await _api.get("${ApiConstants.bookingDetail}/${id}", requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return BookingDetailModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getBookingDetailApi(context: context,id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getBookingDetailApi(context: context,id: id),
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
