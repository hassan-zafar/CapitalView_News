import 'package:flutter/material.dart';

class Language {
  int id;
  String name;
  String languageCode;
  String fullLanguageCode;
  String flag;

  Language(this.id, this.name, this.languageCode, this.flag, this.fullLanguageCode);

  static List<Language> getLanguages() {
    return <Language>[
      Language(0, 'English', 'en', 'assets/flags/ic_us.png', 'en-EN'),
      Language(1, 'ગુજરાતી', 'gu', 'assets/flags/ic_india.png', 'gu-IN'),
      Language(2, 'हिन्दी', 'hi', 'assets/flags/ic_india.png', 'hi-IN'),
      Language(3, 'عربي', 'ar', 'assets/flags/ic_ar.png', 'ar-AR'),
      Language(4, 'Deutsche', 'de', 'assets/flags/ic_germany.png', 'de-DE'),
      Language(5, 'Nederlands', 'nl', 'assets/flags/ic_netherlands.png', 'nl-NL'),
      Language(6, 'русский', 'ru', 'assets/flags/ic_russia.png', 'ru-RU'),
      Language(7, 'Türk', 'tr', 'assets/flags/ic_turkey.png', 'tr-TR'),
      Language(8, 'বাংলা', 'bn', 'assets/flags/ic_bangladesh.png', 'bn-BN'),
      Language(9, 'Français', 'fr', 'assets/flags/ic_french.png', 'fr-FR'),
      Language(10, 'اردو', 'ur', 'assets/flags/ic_pakistan.png', 'ur-UR'),
      Language(11, 'తెలుగు', 'te', 'assets/flags/ic_india.png', 'te-TE'),
      Language(11, 'Italian', 'it', 'assets/flags/ic_italy.png', 'it-IT'),
      Language(12, 'Española', 'es', 'assets/flags/ic_spanish.jpg', 'es-ES'),
      Language(12, 'português', 'pt', 'assets/flags/ic_portugal.png', 'pt-PT'),

    ];
  }

  static List<Language> getLanguagesForTTS() {
    return <Language>[
      Language(0, 'Korean(KR)', '', '', 'ko-KR'),
      Language(1, 'Marathi(IN)', '', '', 'mr-IN'),
      Language(2, 'Russian(RU)', '', '', 'ru-RU'),
      Language(3, 'Chinese(TW)', '', '', 'zh-TW'),
      Language(4, 'Hungarian(HU)', '', '', 'hu-HU'),
      Language(5, 'Thai(TH)', '', '', 'th-TH'),
      Language(6, 'Urdu', '', '', 'ur-PK'),
      Language(7, 'Norwegian', '', '', 'nb-NO'),
      Language(8, 'Danish(DK)', '', '', 'da-DK'),
      Language(9, 'Turkish(TR)', '', '', 'tr-TR'),
      Language(10, 'Estonian(EE)', '', '', 'et-EE'),
      Language(11, 'Bosnian', '', '', 'bs'),
      Language(12, 'Swahili', '', '', 'sw'),
      Language(13, 'Portuguese', '', '', 'pt-PT'),
      Language(14, 'Vietnamese(VN)', '', '', 'vi-VN'),
      Language(15, 'English(US)', '', '', 'en-US'),
      Language(16, 'Swedish(SE)', '', '', 'sv-SE'),
      Language(17, 'Arabic', '', '', 'ar'),
      Language(18, 'Sundanese(ID)', '', '', 'su-ID'),
      Language(19, 'Bengali', '', '', 'bn-BD'),
      Language(20, 'Gujarati(IN)', '', '', 'gu-IN'),
      Language(21, 'Kannada(IN)', '', '', 'kn-IN'),
      Language(22, 'Greek(GR)', '', '', 'el-GR'),
      Language(23, 'Hindi(IN)', '', '', 'hi-IN'),
      Language(24, 'Finnish(FI)', '', '', 'fi-FI'),
      Language(25, 'Khmer', '', '', 'km-KH'),
      Language(26, 'Bengali(IN)', '', '', 'bn-IN'),
      Language(27, 'French(FR)', '', '', 'fr-FR'),
      Language(28, 'Ukrainian(UA)', '', '', 'uk-UA'),
      Language(29, 'English(AU)', '', '', 'en-AU'),
      Language(30, 'Dutch(NL)', '', '', 'nl-NL'),
      Language(31, 'French(CA)', '', '', 'fr-CA'),
      Language(32, 'Serbian', '', '', 'sr'),
      Language(33, 'Portuguese(BR)', '', '', 'pt-BR'),
      Language(34, 'Malayalam(IN)', '', '', 'ml-IN'),
      Language(35, 'Sinhala(LK)', '', '', 'si-LK'),
      Language(36, 'German(DE)', '', '', 'de-DE'),
      Language(37, 'Kurdish', '', '', 'ku'),
      Language(38, 'Czech', '', '', 'cs-CZ'),
      Language(39, 'Polish(PL)', '', '', 'pl-PL'),
      Language(40, 'Slovak(SK)', '', '', 'sk-SK'),
      Language(41, 'Philippines', '', '', 'fil-PH'),
      Language(42, 'Italian(IT)', '', '', 'it-IT'),
      Language(43, 'Nepali', '', '', 'ne-NP'),
      Language(44, 'Croatian', '', '', 'hr'),
      Language(45, 'English(NG)', '', '', 'en-NG'),
      Language(46, 'Chinese(CN)', '', '', 'zh-CN'),
      Language(47, 'Spanish(ES)', '', '', 'es-ES'),
      Language(48, 'Welsh', '', '', 'cy'),
      Language(49, 'Tamil(IN)', '', '', 'ta-IN'),
      Language(50, 'Japanese(JP)', '', '', 'ja-JP'),
      Language(51, 'Albanian', '', '', 'sq'),
      Language(52, 'Hong Kong(HK)', '', '', 'yue-HK'),
      Language(53, 'English(IN)', '', '', 'en-IN'),
      Language(54, 'Spanish(US)', '', '', 'es-US'),
      Language(55, 'Javanese(ID)', '', '', 'jv-ID'),
      Language(56, 'Latin', '', '', 'la'),
      Language(57, 'Indonesian', '', '', 'id-ID'),
      Language(58, 'Telugu(IN)', '', '', 'te-IN'),
      Language(59, 'Romanian(RO)', '', '', 'ro-RO'),
      Language(60, 'Catalan', '', '', 'ca'),
      Language(61, 'English(GB)', '', '', 'en-GB'),
    ];
  }

  static List<String> languages() {
    List<String> list = [];

    getLanguages().forEach((element) {
      list.add(element.languageCode);
    });

    return list;
  }

  static List<Locale> languagesLocale() {
    List<Locale> list = [];

    getLanguages().forEach((element) {
      list.add(Locale(element.languageCode, ''));
    });

    return list;
  }
}
