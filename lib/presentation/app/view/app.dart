import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:enpal/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';

/// The root widget for the Enpal application.
class App extends StatelessWidget {
  const App({super.key, required this.monitoringRepository});

  /// The repository for accessing monitoring data, which is injected
  /// into the application via a `RepositoryProvider`.
  final MonitoringRepository monitoringRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: monitoringRepository,
      child: const AppView(),
    );
  }
}

/// Configures the core view of the application, including theming and the home page.
///
/// `AppView` is responsible for setting up the app's theme (light and dark),
/// disabling the debug banner, and specifying the `HomePage` as the default screen.
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sets the light and dark themes using predefined `EnpalTheme` configurations.
      theme: EnpalTheme.light,
      darkTheme: EnpalTheme.dark,
      debugShowCheckedModeBanner: false, // Hides the debug banner in the app.

      // Specifies `HomePage` as the app's main screen.
      home: const HomePage(),
    );
  }
}
