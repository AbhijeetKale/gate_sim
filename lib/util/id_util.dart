import 'dart:math';

class IdUtil {
  static const String BASE62 =
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  /// NOTE: The way we generate random ids here,
  /// is slightly different from what happens on the server side.
  static final Random _random = Random();

  static String newId({int hash = 0}) {
    String id = '';
    for (int i = 0; i < 7; i++) {
      int n = _random.nextInt(62);
      id = id + BASE62[n];
    }
    return id;
  }
}