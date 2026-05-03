import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/constants/constants.dart';

import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPStorage {
  late SharedPreferences _storage;

  /// settings
  late final _theme = 0.obs;
  late final _showLineNumbers = false.obs;
  late final _fontSize = 0.obs;
  late final _useDynamicColor = true.obs;
  late final _customColorSeed = 0.obs;

  /// auth
  late int _authDefaultTab;

  /// home
  late int _homeDefaultTab;
  late String _mergeRequestFilterScope;
  late String _mergeRequestFilterState;
  late String _issuesFilterScope;
  late String _issuesFilterState;

  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();

    // await _storage.clear();

    /// settings

    _theme.value = _storage.getInt(SPStorageConstants.theme) ?? AppTheme.system;
    _showLineNumbers.value =
        _storage.getBool(SPStorageConstants.showLineNumbers) ?? true;
    _fontSize.value = _storage.getInt(SPStorageConstants.fontSize) ?? 14;
    _useDynamicColor.value = _storage.getBool(SPStorageConstants.useDynamicColor) ?? true;
    _customColorSeed.value = _storage.getInt(SPStorageConstants.customColorSeed) ?? 4280391411; // Colors.lightBlue.value

    /// auth

    _authDefaultTab = _storage.getInt(SPStorageConstants.authDefaultTab) ?? 0;

    /// home

    _homeDefaultTab = _storage.getInt(SPStorageConstants.homeDefaultTab) ?? 0;
    _mergeRequestFilterScope =
        _storage.getString(SPStorageConstants.mergeRequestFilterScope) ??
            MergeRequestScope.all;
    _mergeRequestFilterState =
        _storage.getString(SPStorageConstants.mergeRequestFilterState) ??
            ''; // all
    _issuesFilterScope =
        _storage.getString(SPStorageConstants.issuesFilterScope) ??
            IssuesScope.all;
    _issuesFilterState =
        _storage.getString(SPStorageConstants.issuesFilterState) ?? ''; // all
  }

  /// settings

  Future<void> setTheme(int value) async {
    _theme.value = value;
    await _storage.setInt(SPStorageConstants.theme, value);
  }

  RxInt getTheme() => _theme;

  Future<void> setShowLineNumbers(bool value) async {
    _showLineNumbers.value = value;
    await _storage.setBool(SPStorageConstants.showLineNumbers, value);
  }

  RxBool getShowLineNumbers() => _showLineNumbers;

  Future<void> setFontSize(int value) async {
    _fontSize.value = value;
    await _storage.setInt(SPStorageConstants.fontSize, value);
  }

  RxInt getFontSize() => _fontSize;

  Future<void> setUseDynamicColor(bool value) async {
    _useDynamicColor.value = value;
    await _storage.setBool(SPStorageConstants.useDynamicColor, value);
  }

  RxBool getUseDynamicColor() => _useDynamicColor;

  Future<void> setCustomColorSeed(int value) async {
    _customColorSeed.value = value;
    await _storage.setInt(SPStorageConstants.customColorSeed, value);
  }

  RxInt getCustomColorSeed() => _customColorSeed;

  /// auth

  Future<void> setAuthDefaultTab(int value) async {
    _authDefaultTab = value;
    await _storage.setInt(SPStorageConstants.authDefaultTab, value);
  }

  int getAuthDefaultTab() => _authDefaultTab;

  /// home

  Future<void> setHomeDefaultTab(int value) async {
    _homeDefaultTab = value;
    await _storage.setInt(SPStorageConstants.homeDefaultTab, value);
  }

  int getHomeDefaultTab() => _homeDefaultTab;

  Future<void> setMergeRequestFilterScope(String value) async {
    _mergeRequestFilterScope = value;
    await _storage.setString(SPStorageConstants.mergeRequestFilterScope, value);
  }

  String getMergeRequestFilterScope() => _mergeRequestFilterScope;

  Future<void> setMergeRequestFilterState(String value) async {
    _mergeRequestFilterState = value;
    await _storage.setString(SPStorageConstants.mergeRequestFilterState, value);
  }

  String getMergeRequestFilterState() => _mergeRequestFilterState;

  Future<void> setIssuesFilterScope(String value) async {
    _issuesFilterScope = value;
    await _storage.setString(SPStorageConstants.issuesFilterScope, value);
  }

  String getIssuesFilterScope() => _issuesFilterScope;

  Future<void> setIssuesFilterState(String value) async {
    _issuesFilterState = value;
    await _storage.setString(SPStorageConstants.issuesFilterState, value);
  }

  String getIssuesFilterState() => _issuesFilterState;

  Future<void> resetSettings() async {
    await setTheme(AppTheme.system);
    await setShowLineNumbers(true);
    await setFontSize(14);
    await setUseDynamicColor(true);
    await setCustomColorSeed(4280391411);
  }
}

class AppTheme {
  static const light = 1;
  static const dark = 2;
  static const system = 3;
}

class AppCodeTheme {
  static const light = "vs"; //"github";
  static const dark = "vs2015"; // "dark";
  static const system = "system";
}
