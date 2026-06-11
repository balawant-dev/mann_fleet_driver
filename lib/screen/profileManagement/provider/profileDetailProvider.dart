import 'package:flutter/material.dart';

import '../../../apiservice/services/secure_storage_service.dart';
import '../model/checkMandatoryUpdate.dart';
import '../model/getProfileModel.dart';

import '../repo/profileRepo.dart';

class ProfileDetailProvider extends ChangeNotifier {
  final api = ProfileRepo();

  GetProfileModel? getProfileModel;

  bool isLoading = false;

  Future<void> getProfileApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getProfileApi(context: context);
      getProfileModel = res;
      if (res != null || res.status == true) {
        print("Get Profile Successfully");

        await SecureStorageService.saveFirstUser(
          res.data?.driver?.firstUser ?? false,
        );
        await SecureStorageService.saveProfileComplete(
          res.data?.driver?.isProfileComplete ?? false,
        );
        await SecureStorageService.saveVerified(
          res.data?.driver?.isVerified ?? false,
        );

        final isFirstUser = await SecureStorageService.getFirstUser();
        final isProfileComplete =
            await SecureStorageService.getProfileComplete();
        final isVerified = await SecureStorageService.getVerified();
        print(
          "Api with location storage isFirstUser : ${isFirstUser}  ,isProfileComplete:${isProfileComplete},isVerified ${isVerified}",
        );
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  PlatformDependenciesModel? platformDependenciesModel;
  String? errorMessage;

  Future<void> getPlatformDependenciesApi({
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await api.getPlatformDependenciesApi(context: context);

      platformDependenciesModel = res;
      if (res.data != null &&
          res.data!.first.name!.rGEMNI_API_KEY != null &&
          res.data!.first.name!.rGEMNI_API_KEY!.isNotEmpty) {
        await SecureStorageService.saveGeminiToken(
          res.data!.first.name!.rGEMNI_API_KEY!,
        );
        await SecureStorageService.saveGeminiVersion(
          res.data!.first.name!.rGEMNI_API_VERSION!,
        );
      }
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      platformDependenciesModel = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
