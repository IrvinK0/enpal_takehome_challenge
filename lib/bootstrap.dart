import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:caching/caching.dart';
import 'package:flutter/material.dart';
import 'package:api_client/api_client.dart';

import 'bloc_observer.dart';
import 'domain/repositories/monitoring_repository.dart';
import 'presentation/app/view/app.dart';

/// Initializes and starts the Flutter application.
///
/// The `bootstrap` function sets up global error handling, configures the
/// BLoC observer for logging, initializes the necessary repositories, and
/// starts the app by calling `runApp`. This function is designed to be
/// called once, at the application startup.
void bootstrap({
  required ApiClient apiClient,
  required CachingClient cache,
}) {
  // Configure global error handling to log Flutter framework errors.
  FlutterError.onError = (FlutterErrorDetails details) {
    log(
      details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  // Set up the BLoC observer to log state changes and transitions for debugging.
  Bloc.observer = const AppBlocObserver();

  // Create an instance of the MonitoringRepository with the given API client and cache.
  final monitoringRepository =
      MonitoringRepository(apiClient: apiClient, cache: cache);

  // Run the application, injecting the MonitoringRepository into the App widget.
  runApp(App(monitoringRepository: monitoringRepository));
}
