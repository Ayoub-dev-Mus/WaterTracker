class LanguageData {
  final String flag;
  final String name;
  final String languageCode;
  final String countryCode;

  LanguageData(this.flag, this.name, this.languageCode, this.countryCode);

  static List<LanguageData> languageList() {
    return <LanguageData>[
      LanguageData("🇦🇱", "Albanian", 'sq', 'AL'),
      LanguageData("🇸🇦", "Arabic", 'ar', 'SA'),
      LanguageData("🇦🇿", "Azerbaijani", 'az', 'AF'),
      LanguageData("🇮🇳", "Bengali", 'bn', 'IN'),
      LanguageData("🇲🇲", "Burmese", 'my', 'MM'),
      LanguageData("🇨🇳", "Chinese", 'zh', 'CN'),
      LanguageData("🇭🇷", "Croatian", 'hr', 'HR'),
      LanguageData("🇨🇿", "Czech", 'cs', 'CZ'),
      LanguageData("🇳🇱", "Dutch", 'nl', 'NL'),
      LanguageData("🇺🇸", "English", 'en', 'US'),
      LanguageData("🇫🇷", "French", 'fr', 'FR'),
      LanguageData("🇩🇪", "German", 'de', 'DE'),
      LanguageData("🇬🇷", "Greek", 'el', 'GR'),
      LanguageData("🇮🇳", "Gujarati", 'gu', 'IN'),
      LanguageData("🇮🇳", "Hindi", 'hi', 'IN'),
      LanguageData("🇭🇺", "Hungarian", 'hu', 'HU'),
      LanguageData("🇮🇩", "Indonesian)", 'id', 'ID'),
      LanguageData("🇮🇹", "Italian", 'it', 'IT'),
      LanguageData("🇯🇵", "Japanese", 'ja', 'JP'),
      LanguageData("🇮🇳", "Kannada", 'kn', 'IN'),
      LanguageData("🇰🇵", "Korean", 'ko', 'KR'),
      LanguageData("🇮🇳", "Malayalam", 'ml', 'IN'),
      LanguageData("🇮🇳", "Marathi", 'mr', 'IN'),
      LanguageData("🇳🇴", "Norwegian", 'nb', 'NO'),
      LanguageData("🇮🇳", "Odia", 'or', 'IN'),
      LanguageData("🇮🇷", "Persian", 'fa', 'IR'),
      LanguageData("🇵🇱", "Polish", 'pl', 'PL'),
      LanguageData("🇵🇹", "Portuguese", 'pt', 'PT'),
      LanguageData("🇮🇳", "Punjabi", 'pa', 'IN'),
      LanguageData("🇷🇴", "Romanian", 'ro', 'RO'),
      LanguageData("🇷🇺", "Russian", 'ru', 'RU'),
      LanguageData("🇪🇸", "Spanish", 'es', 'ES'),
      LanguageData("🇸🇪", "Swedish", 'sv', 'SE'),
      LanguageData("🇮🇳", "Tamil", 'ta', 'IN'),
      LanguageData("🇮🇳", "Telugu", 'te', 'IN'),
      LanguageData("🇹🇭", "Thai", 'th', 'TH'),
      LanguageData("🇹🇷", "Turkish", 'tr', 'TR'),
      LanguageData("🇺🇦", "Ukrainian", 'uk', 'UA'),
      LanguageData("🇵🇰", "Urdu", 'ur', 'PK'),
      LanguageData("🇻🇳", "Vietnamese", 'vi', 'VN'),
    ];
  }
}
