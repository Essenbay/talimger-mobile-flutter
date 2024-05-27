import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

bool isTesting = false;

class AppSettingsModel {
  final bool? freeCourses,
      topAuthors,
      categories,
      featured,
      tags,
      skipLogin,
      onBoarding,
      latestCourses,
      contentSecurity;
  final String? supportEmail,
      website,
      privacyUrl,
      kaspiPaymentUrl,
      whatsapp,
      telegram,
      checkingVersion,
      aboutImage,
      aboutDescription;
  final HomeCategory? homeCategory1, homeCategory2, homeCategory3;
  final AppSettingsSocialInfo? social;
  final AdsModel? ads;

  AppSettingsModel({
    required this.freeCourses,
    required this.topAuthors,
    required this.categories,
    required this.whatsapp,
    required this.telegram,
    required this.featured,
    required this.tags,
    required this.kaspiPaymentUrl,
    required this.skipLogin,
    required this.onBoarding,
    required this.supportEmail,
    required this.website,
    required this.privacyUrl,
    required this.homeCategory1,
    required this.homeCategory2,
    required this.homeCategory3,
    required this.social,
    required this.latestCourses,
    required this.ads,
    required this.contentSecurity,
    required this.checkingVersion,
    required this.aboutDescription,
    required this.aboutImage,
  });

  factory AppSettingsModel.fromFirestore(DocumentSnapshot snap) {
    final Map d = snap.data() as Map<String, dynamic>;
    final model = AppSettingsModel(
      featured: d['featured'] ?? true,
      topAuthors: d['top_authors'] ?? true,
      categories: d['categories'] ?? true,
      freeCourses: d['free_courses'] ?? true,
      onBoarding: d['onboarding'] ?? true,
      skipLogin: d['skip_login'] ?? true,
      kaspiPaymentUrl: d['kaspi_url'],
      latestCourses: d['latest_courses'] ?? true,
      tags: d['tags'] ?? true,
      supportEmail: d['email'],
      privacyUrl: d['privacy_url'],
      checkingVersion: d['checkingVersion'],
      whatsapp: d['whatsapp'],
      telegram: d['telegram'],
      website: d['website'],
      homeCategory1:
          d['category1'] != null ? HomeCategory.fromMap(d['category1']) : null,
      homeCategory2:
          d['category2'] != null ? HomeCategory.fromMap(d['category2']) : null,
      homeCategory3:
          d['category3'] != null ? HomeCategory.fromMap(d['category3']) : null,
      social: d['social'] != null
          ? AppSettingsSocialInfo.fromMap(d['social'])
          : null,
      ads: d['ads'] != null ? AdsModel.fromMap(d['ads']) : null,
      contentSecurity: d['content_security'] ?? false,
      aboutDescription: d['about_description'],
      aboutImage: d['about_image'],
    );
    model.setTesting();
    return model;
  }

  Future<void> setTesting() async {
    final info = await PackageInfo.fromPlatform();
    final version = info.version;
    isTesting = Platform.isIOS && version == checkingVersion;
  }
}

class HomeCategory {
  final String id, name;

  HomeCategory({required this.id, required this.name});

  factory HomeCategory.fromMap(Map<String, dynamic> d) {
    return HomeCategory(
      id: d['id'],
      name: d['name'],
    );
  }
}

class AppSettingsSocialInfo {
  final String? fb, youtube, twitter, instagram;

  AppSettingsSocialInfo(
      {required this.fb,
      required this.youtube,
      required this.twitter,
      required this.instagram});

  factory AppSettingsSocialInfo.fromMap(Map<String, dynamic> d) {
    return AppSettingsSocialInfo(
      fb: d['fb'],
      youtube: d['youtube'],
      instagram: d['instagram'],
      twitter: d['twitter'],
    );
  }
}

class AdsModel {
  final bool? isAdsEnabled, bannerEnbaled, interstitialEnabled;

  AdsModel({
    this.isAdsEnabled,
    this.bannerEnbaled,
    this.interstitialEnabled,
  });

  factory AdsModel.fromMap(Map<String, dynamic> d) {
    return AdsModel(
      isAdsEnabled: d['enabled'] ?? false,
      bannerEnbaled: d['banner'] ?? false,
      interstitialEnabled: d['interstitial'] ?? false,
    );
  }
}
