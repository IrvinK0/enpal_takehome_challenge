import 'package:enpal/domain/models/models.dart';
import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:enpal/presentation/app/view/app.dart';
import 'package:enpal/presentation/home/view/view.dart';
import 'package:enpal/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMonitoringRepository extends Mock implements MonitoringRepository {}

void main() {
  late MonitoringRepository repository;

  setUpAll(() {
    registerFallbackValue(MonitoringType.solar);
  });

  setUp(() {
    repository = MockMonitoringRepository();
    when(
      () => repository.getMonitoringData(
          date: any(named: 'date'), type: any(named: 'type')),
    ).thenAnswer((_) async => List.empty());
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(monitoringRepository: repository),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders MaterialApp with correct themes', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: repository,
          child: const AppView(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, equals(EnpalTheme.light));
      expect(materialApp.darkTheme, equals(EnpalTheme.dark));
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: repository,
          child: const AppView(),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
