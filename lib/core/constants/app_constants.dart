class AppConstants{
  //Contruktor als private deklarieren und somit verhindern, dass die Klasse instanziiert wird von außen
  const AppConstants._();

  static const String appName = "Audiobook Meme Reader";
  static const String logFile = "app_logs.log";
  static const String appVersion = "0.0.1";
  static const String logDir = "logs";
  static const String DefaultLanguage = "de";
  static const String audioDir = 'audio';
  static const String cachedir = 'cache';
}
