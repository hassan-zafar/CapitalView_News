import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:mighty_news/main.dart';
import 'package:mighty_news/models/BaseResponse.dart' as BR;
import 'package:mighty_news/models/CategoryData.dart';
import 'package:mighty_news/models/CommentData.dart';
import 'package:mighty_news/models/DashboardResponse.dart';
import 'package:mighty_news/models/LoginResponse.dart';
import 'package:mighty_news/models/RegisterResponse.dart';
import 'package:mighty_news/models/SearchNewsResponse.dart';
import 'package:mighty_news/models/TweetModel.dart';
import 'package:mighty_news/models/WeatherResponse.dart';
import 'package:mighty_news/network/NetworkUtils.dart';
import 'package:mighty_news/screens/DashboardScreen.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

//region Third Party APIs
Future<WeatherResponse> getWeatherApi() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    Position? position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      position = await Geolocator.getCurrentPosition();
    }

    return WeatherResponse.fromJson(await (handleResponse(await buildHttpResponse('$mWeatherBaseUrl?key=$mWeatherAPIKey&q=${position.latitude},${position.longitude}'), true)));
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<List<TweetModel>> loadTweetConfig() async {
  AuthCredential credential = TwitterAuthProvider.credential(accessToken: mTwitterApiAccessToken, secret: mTwitterApiAccessTokenSecret);

  return FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
    final String proxy = isWeb ? "http://localhost:8888/" : "";

    final String authUrl = "${proxy}https://api.twitter.com/oauth2/token";
    final String key = Uri.encodeQueryComponent(mTwitterApiKey);
    final String secret = Uri.encodeQueryComponent(mTwitterApiSecretKey);
    final Uint8List bytes = AsciiEncoder().convert("$key:$secret");
    final String auth = base64Encode(bytes);

    Response authRes = await post(
      Uri.parse(authUrl),
      headers: {"Authorization": "Basic $auth", "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"},
      body: "grant_type=client_credentials",
    );

    Map decoded = jsonDecode(authRes.body);

    if (isIos) {
      await setValue(TWITTER_USERNAME, value.additionalUserInfo!.profile!['screen_name']);
    } else {
      await setValue(TWITTER_USERNAME, value.additionalUserInfo!.username.validate());
    }

    await setValue(TWITTER_ACCESS_TOKEN, decoded['access_token']);
    await setValue(IS_TWITTER_LOGGED_IN, true);

    FirebaseAuth.instance.signOut();

    if (retryCount > 2) {
      //retryCount = 0;

      throw '';
    }
    return await loadTweets();
  }).catchError((e) {
    retryCount++;
  });
}

Future<List<TweetModel>> loadTweets() async {
  return await get(
    Uri.parse('https://api.twitter.com/1.1/statuses/user_timeline.json?tweet_mode=extended&screen_name=${getStringAsync(TWITTER_USERNAME)}'),
    headers: {'Authorization': 'Bearer ${getStringAsync(TWITTER_ACCESS_TOKEN)}'},
  ).then((timelineRes) async {
    if (timelineRes.statusCode.isSuccessful()) {
      retryCount = 0;
      log('Response: ${timelineRes.body}');

      Iterable it = jsonDecode(timelineRes.body);
      return it.map((e) => TweetModel.fromJson(e)).toList();
    } else {
      retryCount++;
      await setValue(IS_TWITTER_LOGGED_IN, false);

      return await loadTweetConfig();
    }
  }).catchError((e) {
    retryCount++;
    throw e;
  });
}
//endregion

//region User Authentications
Future validateToken() async {
  return await handleResponse(await buildHttpResponse('jwt-auth/v1/token/validate', request: {}, method: HttpMethod.POST));
}

Future<LoginResponse> login(Map request, {bool isSocialLogin = false}) async {
  Response response = await buildHttpResponse(isSocialLogin ? 'news/api/v1/mighty/social_login' : 'jwt-auth/v1/token', request: request, method: HttpMethod.POST);

  if (!response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);

      if (json.containsKey('code') && json['code'].toString().contains('invalid_username')) {
        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((json) async {
    var loginResponse = LoginResponse.fromJson(json);

    await setValue(TOKEN, loginResponse.token.validate());
    await setValue(USER_ID, loginResponse.user_id.validate());
    await setValue(FIRST_NAME, loginResponse.first_name.validate());
    await setValue(LAST_NAME, loginResponse.last_name.validate());
    await setValue(USER_EMAIL, loginResponse.user_email.validate());
    await setValue(USERNAME, loginResponse.user_nicename.validate());

    await setValue(USER_DISPLAY_NAME, loginResponse.user_display_name.validate());
    if (loginResponse.my_topics != null) await setValue(MY_TOPICS, jsonEncode(loginResponse.my_topics));

    if (request['loginType'] == LoginTypeGoogle) {
      await setValue(PROFILE_IMAGE, request['photoURL']);
    } else {
      await setValue(PROFILE_IMAGE, loginResponse.profile_image.validate());
    }

    if (!isSocialLogin) await setValue(PASSWORD, request['password']);
    await setValue(LOGIN_TYPE, request['loginType'] ?? LoginTypeApp);
    await setValue(IS_SOCIAL_LOGIN, isSocialLogin.validate());

    if (loginResponse.myPreference != null) {
      await setValue(MY_PREFERENCE, jsonEncode(loginResponse.myPreference));

      if (loginResponse.myPreference!.detailVariant.validate() == 0) {
        await setValue(DETAIL_PAGE_VARIANT, 1);
      } else {
        await setValue(DETAIL_PAGE_VARIANT, loginResponse.myPreference!.detailVariant.validate(value: 1));
      }

      await setValue(THEME_MODE_INDEX, loginResponse.myPreference!.themeMode.validate());
      if (loginResponse.myPreference!.themeMode.validate() == ThemeModeLight || loginResponse.myPreference!.themeMode.validate() == ThemeModeDark) {
        if (loginResponse.myPreference!.themeMode.validate() == ThemeModeLight) {
          appStore.setDarkMode(false);
        } else if (loginResponse.myPreference!.themeMode.validate() == ThemeModeDark) {
          appStore.setDarkMode(true);
        }
      }
    }

    appStore.setUserEmail(loginResponse.user_email);
    appStore.setUserId(loginResponse.user_id);
    appStore.setFirstName(loginResponse.first_name);
    appStore.setLastName(loginResponse.last_name);
    appStore.setMyTopics(loginResponse.my_topics.validate());
    appStore.setLoggedIn(true);

    if (isSocialLogin) {
      FirebaseAuth.instance.signOut();

      await setValue(IS_REMEMBERED, true);
    } else {
      appStore.setUserProfile(loginResponse.profile_image);
    }
    return loginResponse;
  }).catchError((e) {
    log(e);
    throw e.toString();
  });
}

Future<void> logout(BuildContext context) async {
  await removeKey(TOKEN);
  await removeKey(USER_ID);
  await removeKey(FIRST_NAME);
  await removeKey(LAST_NAME);
  await removeKey(USERNAME);
  await removeKey(USER_DISPLAY_NAME);
  await removeKey(MY_TOPICS);
  await removeKey(PROFILE_IMAGE);
  await removeKey(IS_LOGGED_IN);

  if (getBoolAsync(IS_SOCIAL_LOGIN) || getStringAsync(LOGIN_TYPE) == LoginTypeOTP || !getBoolAsync(IS_REMEMBERED)) {
    await removeKey(PASSWORD);
    await removeKey(USER_EMAIL);
  }

  appStore.setLoggedIn(false);
  appStore.setMyTopics([]);

  DashboardScreen().launch(context, isNewTask: true);
}

Future<RegisterResponse> createUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/auth/register', request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> viewProfile() async {
  return LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/view-profile'))));
}

Future<LoginResponse> updateUser(id, Map request) async {
  return LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/update-profile', request: request, method: HttpMethod.POST))));
}

Future<BR.BaseResponse> forgotPassword(Map request) async {
  return BR.BaseResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/forgot-password', request: request, method: HttpMethod.POST))));
}

Future<BR.BaseResponse> changePassword(Map request) async {
  return BR.BaseResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/change-password', request: request, method: HttpMethod.POST))));
}

Future<bool?> updateProfile({String? firstName, String? lastName, File? file, String? toastMessage, bool showToast = true}) async {
  var multiPartRequest = MultipartRequest('POST', Uri.parse('$mBaseUrl${'news/api/v1/mighty/update-profile'}'));

  multiPartRequest.fields['first_name'] = firstName ?? getStringAsync(FIRST_NAME);
  multiPartRequest.fields['last_name'] = lastName ?? getStringAsync(LAST_NAME);
  multiPartRequest.fields['my_topics'] = jsonEncode(appStore.myTopics);
  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));

  Map map = {
    'detailVariant': getIntAsync(DETAIL_PAGE_VARIANT),
    'themeMode': getIntAsync(THEME_MODE_INDEX),
  };
  multiPartRequest.fields['my_preference'] = jsonEncode(map);

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log(multiPartRequest.fields);
  Response response = await Response.fromStream(await multiPartRequest.send());
  log(response.body);

  if (response.statusCode.isSuccessful()) {
    Map<String, dynamic> res = jsonDecode(response.body);
    LoginResponse data = LoginResponse.fromJson(res);

    await setValue(FIRST_NAME, data.first_name);
    await setValue(LAST_NAME, data.last_name);

    appStore.setFirstName(data.first_name);
    appStore.setLastName(data.last_name);

    if (data.profile_image != null) {
      await setValue(PROFILE_IMAGE, data.profile_image);
      appStore.setUserProfile(data.profile_image);
    }

    if (data.my_topics != null) {
      appStore.setMyTopics(data.my_topics!);
      await setValue(MY_TOPICS, jsonEncode(data.my_topics));
    }

    if (data.myPreference != null) {
      await setValue(MY_PREFERENCE, jsonEncode(data.myPreference));

      if (data.myPreference!.detailVariant.validate() == 0) {
        await setValue(DETAIL_PAGE_VARIANT, 1);
      } else {
        await setValue(DETAIL_PAGE_VARIANT, data.myPreference!.detailVariant.validate(value: 1));
      }

      await setValue(THEME_MODE_INDEX, data.myPreference!.themeMode.validate());
    }

    if (showToast) toast(toastMessage ?? 'Profile updated successfully');

    return true;
  } else {
    toast(errorSomethingWentWrong);
    return false;
  }
}

//endregion

//region News List
Future<SearchNewsResponse> getWishList(int page) async {
  return SearchNewsResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/get-fav-list?paged=$page&posts_per_page=$postsPerPage'))));
}

Future<SearchNewsResponse> blogFilterNewsApi(Map? request, int page) async {
  return SearchNewsResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/get-blog-by-filter?paged=$page', request: request, method: HttpMethod.POST))));
}

Future<DashboardResponse> getDashboardApi(Map request, int page) async {
  if (!(await isNetworkAvailable()) && getStringAsync(DASHBOARD_DATA).isNotEmpty) {
    return DashboardResponse.fromJson(jsonDecode(getStringAsync(DASHBOARD_DATA)));
  }
  return await handleResponse(await buildHttpResponse('news/api/v1/mighty/get-dashboard?paged=$page', request: request, method: HttpMethod.POST)).then((value) async {
    var res = DashboardResponse.fromJson(value);

    await setValue(DASHBOARD_DATA, jsonEncode(res));
    if (res.social_link != null) {
      await setValue(TERMS_AND_CONDITION_PREF, res.social_link!.termCondition.validate());
      await setValue(PRIVACY_POLICY_PREF, res.social_link!.privacyPolicy.validate());
      await setValue(CONTACT_PREF, res.social_link!.contact.validate());
      await setValue(DISABLE_AD, res.social_link!.disableAd.validate());
      await setValue(DISABLE_LOCATION_WIDGET, res.social_link!.disableLocation.validate());
      await setValue(DISABLE_TWITTER_WIDGET, res.social_link!.disableTwitter.validate());
      await setValue(DISABLE_HEADLINE_WIDGET, res.social_link!.disableHeadline.validate());
      await setValue(DISABLE_QUICK_READ_WIDGET, res.social_link!.disableQuickRead.validate());
      await setValue(DISABLE_STORY_WIDGET, res.social_link!.disableStory.validate());
      await setValue(COPYRIGHT_TEXT, res.social_link!.copyright_text.validate());
    }
    return res;
  }).catchError((e) async {
    if (!await isNetworkAvailable() && getStringAsync(DASHBOARD_DATA).isNotEmpty) {
      return DashboardResponse.fromJson(jsonDecode(getStringAsync(DASHBOARD_DATA)));
    }

    throw e.toString();
  });
}

Future<NewsData> getBlogDetail(Map request, bool isLogin) async {
  return NewsData.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/get-post-details', request: request, method: HttpMethod.POST))));
}
//endregion

Future<List<CategoryData>> getCategories({int? page, int perPage = 100, int? parent}) async {
  if (!(await isNetworkAvailable()) && getStringAsync(CATEGORY_DATA).isNotEmpty) {
    Iterable it = jsonDecode(getStringAsync(CATEGORY_DATA));
    return it.map((e) => CategoryData.fromJson(e)).toList();
  } else {
    Iterable it = await (handleResponse(await buildHttpResponse('news/api/v1/mighty/get-category?parent=${parent ?? 0}&page=${page ?? 1}&per_page=$perPage')));
    return it.map((e) => CategoryData.fromJson(e)).toList();
  }
}

Future addWishList(Map request) async {
  return handleResponse(await buildHttpResponse('news/api/v1/mighty/add-fav-list', request: request, method: HttpMethod.POST));
}

Future<BR.BaseResponse> removeWishList(Map request) async {
  return BR.BaseResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/delete-fav-list', request: request, method: HttpMethod.POST))));
}

Future<List<VideoData>> getVideos(int page) async {
  Iterable it = await (handleResponse(await buildHttpResponse('news/api/v1/mighty/get-video-list?paged=$page&posts_per_page=$postsPerPage')));
  return it.map((e) => VideoData.fromJson(e)).toList();
}

Future<List<CommentData>> getCommentList(int? id) async {
  Iterable res = await (handleResponse(await buildHttpResponse('wp/v2/comments/?post=$id')));
  return res.map((e) => CommentData.fromJson(e)).toList();
}

Future<BR.BaseResponse> postComment(Map request) async {
  return BR.BaseResponse.fromJson(await (handleResponse(await buildHttpResponse('news/api/v1/mighty/post-comment', request: request, method: HttpMethod.POST))));
}

Future<void> removeComment({int? id, force = false}) async {
  return await (handleResponse(await buildHttpResponse('news/api/v1/mighty/delete-comment?id=$id&force=$force')));
}
