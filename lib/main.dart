import 'dart:io';

import 'package:enpal/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:api_client/api_client.dart';
import 'package:caching/caching.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cache =
      await SharedPreferencesClient.create(prefix: Constants.cachingKey);
  final apiClient = RemoteApiClient(
      baseUrl:
          Platform.isAndroid ? Constants.androidBaseUri : Constants.iOSBaseUri);

  bootstrap(apiClient: apiClient, cache: cache);
}
