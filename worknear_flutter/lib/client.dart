import 'package:flutter/foundation.dart';

import 'package:worknear_client/worknear_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

final serverUrl = getServerUrl();

late final Client client;

Future<void> initializeClient() async {
  client = Client(await serverUrl)
    ..cookieAuth = kIsWeb
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  try {
    await client.auth.initialize();
  } catch (e) {
    debugPrint('No existing auth session: $e');
  }
}