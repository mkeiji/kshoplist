import 'package:flutter/foundation.dart';
import 'dart:js' as js;

class Env {
  static String get wsUrl {
    if (kIsWeb) {
      final jsEnv = js.context['__env__'];
      if (jsEnv != null && jsEnv['WS_URL'] != null) {
        return jsEnv['WS_URL'];
      }
    }

    return const String.fromEnvironment(
      'WS_URL',
      defaultValue: 'ws://localhost:8081/ws/1',
    );
  }
}
