// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$isNotificationOnAtom = Atom(name: '_AppStore.isNotificationOn');

  @override
  bool get isNotificationOn {
    _$isNotificationOnAtom.reportRead();
    return super.isNotificationOn;
  }

  @override
  set isNotificationOn(bool value) {
    _$isNotificationOnAtom.reportWrite(value, super.isNotificationOn, () {
      super.isNotificationOn = value;
    });
  }

  final _$isDarkModeAtom = Atom(name: '_AppStore.isDarkMode');

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$selectedLanguageCodeAtom = Atom(name: '_AppStore.selectedLanguageCode');

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode, () {
      super.selectedLanguageCode = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage');

  @override
  String? get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String? value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$userFirstNameAtom = Atom(name: '_AppStore.userFirstName');

  @override
  String? get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String? value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  final _$userLastNameAtom = Atom(name: '_AppStore.userLastName');

  @override
  String? get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String? value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String? get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String? value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  int? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$myTopicsAtom = Atom(name: '_AppStore.myTopics');

  @override
  List<int?> get myTopics {
    _$myTopicsAtom.reportRead();
    return super.myTopics;
  }

  @override
  set myTopics(List<int?> value) {
    _$myTopicsAtom.reportWrite(value, super.myTopics, () {
      super.myTopics = value;
    });
  }

  final _$languageForTTSAtom = Atom(name: '_AppStore.languageForTTS');

  @override
  String get languageForTTS {
    _$languageForTTSAtom.reportRead();
    return super.languageForTTS;
  }

  @override
  set languageForTTS(String value) {
    _$languageForTTSAtom.reportWrite(value, super.languageForTTS, () {
      super.languageForTTS = value;
    });
  }

  final _$appBarThemeAtom = Atom(name: '_AppStore.appBarTheme');

  @override
  AppBarTheme get appBarTheme {
    _$appBarThemeAtom.reportRead();
    return super.appBarTheme;
  }

  @override
  set appBarTheme(AppBarTheme value) {
    _$appBarThemeAtom.reportWrite(value, super.appBarTheme, () {
      super.appBarTheme = value;
    });
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  final _$setDarkModeAsyncAction = AsyncAction('_AppStore.setDarkMode');

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  final _$setLanguageAsyncAction = AsyncAction('_AppStore.setLanguage');

  @override
  Future<void> setLanguage(String aSelectedLanguageCode, {BuildContext? context}) {
    return _$setLanguageAsyncAction.run(() => super.setLanguage(aSelectedLanguageCode, context: context));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setTTSLanguage(String lang) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setTTSLanguage');
    try {
      return super.setTTSLanguage(lang);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMyTopics(List<int> val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setMyTopics');
    try {
      return super.setMyTopics(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToMyTopics(int? val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.addToMyTopics');
    try {
      return super.addToMyTopics(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromMyTopics(int? val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.removeFromMyTopics');
    try {
      return super.removeFromMyTopics(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserProfile(String? image) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setUserProfile');
    try {
      return super.setUserProfile(image);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserId(int? val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setUserId');
    try {
      return super.setUserId(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserEmail(String? email) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setUserEmail');
    try {
      return super.setUserEmail(email);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFirstName(String? name) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setFirstName');
    try {
      return super.setFirstName(name);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastName(String? name) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setLastName');
    try {
      return super.setLastName(name);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotification(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setNotification');
    try {
      return super.setNotification(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isNotificationOn: ${isNotificationOn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
selectedLanguageCode: ${selectedLanguageCode},
userProfileImage: ${userProfileImage},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
userEmail: ${userEmail},
userId: ${userId},
myTopics: ${myTopics},
languageForTTS: ${languageForTTS},
appBarTheme: ${appBarTheme}
    ''';
  }
}
