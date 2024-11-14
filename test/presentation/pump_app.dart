import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMonitoryRepository extends Mock implements MonitoringRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    MonitoringRepository? monitorRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: monitorRepository ?? MockMonitoryRepository(),
        child: MaterialApp(home: Scaffold(body: widget)),
      ),
    );
  }

  Future<void> pumpRoute(
    Route<dynamic> route, {
    MonitoringRepository? monitorRepository,
  }) {
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
      monitorRepository: monitorRepository,
    );
  }
}
