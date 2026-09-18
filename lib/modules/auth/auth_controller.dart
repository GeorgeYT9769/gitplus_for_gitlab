import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gitplus_for_gitlab/api/api.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/models/request/access_token_request_password.dart';
import 'package:gitplus_for_gitlab/routes/app_pages.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:get/get.dart';

class AuthController extends GetxController with HttpController {
  final ApiRepository apiRepository;
  AuthController({required this.apiRepository});
  final _prefs = Get.find<SecureStorage>();
  final _spStorage = Get.find<SPStorage>();

  final textcontroller = TextEditingController(text: 'gitlab.com');
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final accessTokenController = TextEditingController();

  var selectedTab = 0.obs;

  var isHttps = true.obs;
  var canShowExternalContent = false.obs;

  var _authCode = "";

  var prefix = "https".obs;
  var _baseUrl = "";

  @override
  void onReady() {
    selectedTab.value = _spStorage.getAuthDefaultTab();

    var dt = DateTime.parse('20220727');
    if (dt.isBefore(DateTime.now()) || (!Platform.isIOS && !Platform.isMacOS)) {
      canShowExternalContent.value = true;
    }

    super.onReady();
  }

  void navigationDelegate(Uri? uri) {
    String error = "";

    uri!.queryParameters.forEach((k, v) async {
      if (k.contains("error")) {
        error = v;
      } else if (k.toString() == "code") {
        _authCode = v;
      }
    });

    if (error.isNotEmpty) {
      CommonWidget.toast(error);
      Get.back();
    } else {
      reqAccessToken();
    }
  }

  void reqAccessToken() async {
    await _prefs.setBaseUrl(_baseUrl);

    EasyLoading.show();

    final res = await apiRepository.accessToken(
      AccessTokenReqest(
          clientId:
              "0cb34efc253db99fce721cb192b7f384659b566be65c30d3a30f95234818e28b",
          clientSecret:
              "6657a92ac98e4e6c497d9994f05f235e30dce40f83c5063128acf1416a7ea4ba",
          code: _authCode,
          grantType: "authorization_code",
          redirectUri: "com.gitlabplus.app://auth",
          codeVerifier:
              "UQ0kg-XnIExbwzv0RfrvyEzDoqJGCwNQ_USdc-FBthmdOIiUs4xL2.67.~vj.9xjM7CTGOIDAAm2QQs_3.O~8TKR-eUlHetE-hER00fwMIEz6iYOj36nn8xm4ed39RLz"),
    );

    if (res != null && res.accessToken!.isNotEmpty) {
      await _prefs.setToken(res.accessToken!);

      var user = await apiRepository.getUser();
      if (user != null) {
        var acc = AppAccount(
            userId: user.id,
            name: user.name,
            baseUrl: _baseUrl,
            username: user.username,
            avatarUrl: user.avatarUrl,
            accessToken: res.accessToken,
            refreshToken: res.refreshToken);

        await _prefs.addUpdateAccount(acc);

        await _prefs.setDefaultAccount(acc);

        Get.offAllNamed(Routes.home);
      } else {
        handleErr();
      }
    } else {
      handleErr();
    }
    EasyLoading.dismiss();
  }

  void handleErr() {}

  @override
  void onClose() {
    textcontroller.dispose();
    super.onClose();
  }

  Future<String> _discoverBaseUrl(String serverText) async {
    var text = serverText.trim();
    if (text.isEmpty) return "https://gitlab.com";
    if (text.startsWith('http://') || text.startsWith('https://')) {
      if (text.endsWith('/')) text = text.substring(0, text.length - 1);
      return text;
    }
    var candidateHttps = "https://$text";
    if (candidateHttps.endsWith('/')) candidateHttps = candidateHttps.substring(0, candidateHttps.length - 1);
    var candidateHttp = "http://$text";
    if (candidateHttp.endsWith('/')) candidateHttp = candidateHttp.substring(0, candidateHttp.length - 1);

    try {
      final probeDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));
      await probeDio.get(candidateHttps);
      return candidateHttps;
    } on DioException catch (e) {
      if (e.response != null) return candidateHttps;
    } catch (_) {}

    try {
      final probeDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));
      await probeDio.get(candidateHttp);
      return candidateHttp;
    } on DioException catch (e) {
      if (e.response != null) return candidateHttp;
    } catch (_) {}

    return "${prefix.value}://$text";
  }

  Future<void> submitPassAuth() async {
    EasyLoading.show(status: 'Discovering server...');
    _baseUrl = await _discoverBaseUrl(textcontroller.text);
    await _prefs.setBaseUrl(_baseUrl);
    EasyLoading.show(status: 'Logging in...');

    try {
      var res = await apiRepository.signInPassword(AccessTokenReqestPassword(
          grantType: 'password',
          username: nameController.text,
          password: passController.text));

      if (res != null && res.accessToken!.isNotEmpty) {
        await _prefs.setToken(res.accessToken!);

        var user = await apiRepository.getUser();
        if (user != null) {
          var avatarUrl = user.avatarUrl ?? "";
          if (avatarUrl.isNotEmpty && !avatarUrl.startsWith('http')) {
            avatarUrl = _baseUrl + avatarUrl;
          }
          var acc = AppAccount(
              userId: user.id,
              name: user.name,
              baseUrl: _baseUrl,
              username: user.username,
              avatarUrl: avatarUrl,
              accessToken: res.accessToken,
              refreshToken: res.refreshToken);

          await _prefs.addUpdateAccount(acc);

          await _prefs.setDefaultAccount(acc);

          Get.offAllNamed(Routes.home);
        } else {
          handleErr();
        }
      } else {
        handleErr();
      }
    } on DioException {
      CommonWidget.toast('Unauthorized');
    }

    EasyLoading.dismiss();
  }

  void onTabChanged(int index) {
    _spStorage.setAuthDefaultTab(index);
    selectedTab.value = index;
  }

  Future<void> submitAccessTokenAuth() async {
    EasyLoading.show(status: 'Discovering server...');
    _baseUrl = await _discoverBaseUrl(textcontroller.text);
    await _prefs.setBaseUrl(_baseUrl);

    await _prefs.setToken(accessTokenController.text);

    EasyLoading.show(status: 'Authenticating...');

    try {
      var user = await apiRepository.getUser();
      var avatarUrl = user?.avatarUrl ?? "";
      if (avatarUrl.isNotEmpty && !avatarUrl.startsWith('http')) {
        avatarUrl = _baseUrl + avatarUrl;
      }
      var acc = AppAccount(
          userId: user!.id,
          name: user.name,
          baseUrl: _baseUrl,
          username: user.username,
          avatarUrl: avatarUrl,
          accessToken: accessTokenController.text);
      await _prefs.addUpdateAccount(acc);

      await _prefs.setDefaultAccount(acc);

      Get.offAllNamed(Routes.home);
    } on DioException {
      CommonWidget.toast('Unauthorized');
    }

    EasyLoading.dismiss();
  }
}
