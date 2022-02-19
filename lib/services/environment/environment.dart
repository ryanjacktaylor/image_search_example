
class Environment{
  Environment._privateConstructor();

  static final Environment _instance = Environment._privateConstructor();

  static Environment get instance => _instance;

  static const String API_KEY = 'API_KEY';

  String apiKey(){
    return const String.fromEnvironment(API_KEY, defaultValue: '');
  }
}