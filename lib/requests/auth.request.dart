import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/services/firebase_token.service.dart';
import 'package:fuodz/services/http.service.dart';

class AuthRequest extends HttpService {
  //
  Future<ApiResponse> loginRequest({
    required String email,
    required String password,
  }) async {
    final apiResult = await post(Api.login, {
      "email": email,
      "password": password,
      "tokens": await FirebaseTokenService().getDeviceToken(),
    });

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> qrLoginRequest({required String code}) async {
    final apiResult = await post(Api.qrlogin, {
      "code": code,
      "tokens": await FirebaseTokenService().getDeviceToken(),
    });

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> resetPasswordRequest({
    required String phone,
    required String password,
    String? firebaseToken,
    String? customToken,
  }) async {
    final apiResult = await post(Api.forgotPassword, {
      "phone": phone,
      "password": password,
      "firebase_id_token": firebaseToken,
      "verification_token": customToken,
    });

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> registerRequest({
    required String name,
    required String email,
    required String phone,
    required String countryCode,
    required String password,
    String code = "",
  }) async {
    final apiResult = await post(Api.register, {
      "name": name,
      "email": email,
      "phone": phone,
      "country_code": countryCode,
      "password": password,
      "code": code,
      "role": "client",
      "tokens": await FirebaseTokenService().getDeviceToken(),
    });

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> logoutRequest() async {
    final apiResult = await get(Api.logout);
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> updateProfile({
    File? photo,
    String? name,
    String? email,
    String? phone,
    String? countryCode,
  }) async {
    final apiResult = await postWithFiles(Api.updateProfile, {
      "_method": "PUT",
      "name": name,
      "email": email,
      "phone": phone,
      "country_code": countryCode,
      "photo": photo != null ? await MultipartFile.fromFile(photo.path) : null,
    });
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updatePassword({
    String? password,
    String? new_password,
    String? new_password_confirmation,
  }) async {
    final apiResult = await post(Api.updatePassword, {
      "_method": "PUT",
      "password": password,
      "new_password": new_password,
      "new_password_confirmation": new_password_confirmation,
    });
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> verifyPhoneAccount(String phone) async {
    final apiResult = await get(
      Api.verifyPhoneAccount,
      queryParameters: {"phone": phone},
    );

    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> sendOTP(
    String phoneNumber, {
    bool isLogin = false,
  }) async {
    final apiResult = await post(Api.sendOtp, {
      "phone": phoneNumber,
      "is_login": isLogin,
    });
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message ?? apiResponse;
    }
  }

  Future<ApiResponse> verifyOTP(
    String phoneNumber,
    String code, {
    bool isLogin = false,
  }) async {
    final apiResult = await post(Api.verifyOtp, {
      "phone": phoneNumber,
      "code": code,
      "is_login": isLogin,
      "tokens": await FirebaseTokenService().getDeviceToken(),
    });
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message ?? apiResponse;
    }
  }

  //
  Future<ApiResponse> verifyFirebaseToken(
    String phoneNumber,
    String firebaseVerificationId,
  ) async {
    //
    final apiResult = await post(Api.verifyFirebaseOtp, {
      "phone": phoneNumber,
      "firebase_id_token": firebaseVerificationId,
    });
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message ?? apiResponse;
    }
  }

  //
  Future<ApiResponse?> socialLogin(
    String email,
    String? firebaseVerificationId,
    String provider, {
    String? nonce,
    String? uid,
  }) async {
    //
    final apiResult = await post(Api.socialLogin, {
      "provider": provider,
      "email": email,
      "firebase_id_token": firebaseVerificationId,
      "nonce": nonce,
      "uid": uid,
      "tokens": await FirebaseTokenService().getDeviceToken(),
    });
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else if (apiResponse.code == 401) {
      return null;
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse> deleteProfile({String? password, String? reason}) async {
    final apiResult = await post(Api.accountDelete, {
      "_method": "DELETE",
      "password": password,
      "reason": reason,
    });
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updateDeviceToken(String token) async {
    late String deviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.manufacturer;
      deviceId += "-";
      deviceId += androidInfo.model;
      deviceId += "-";
      deviceId += androidInfo.id;
    }
    final apiResult = await post(Api.tokenSync, {
      "token": token,
      "deviceId": deviceId,
    });
    return ApiResponse.fromResponse(apiResult);
  }
}
