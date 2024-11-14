import 'package:bloc_test/bloc_test.dart';
import 'package:enpal/core/constants/constants.dart';
import 'package:enpal/domain/models/models.dart';
import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:enpal/presentation/home/home.dart';
import 'package:enpal/presentation/home/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../pump_app.dart';

class MockMonitoringRepository extends Mock implements MonitoringRepository {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

void main() {
  final mockMonitorings = {
    MonitoringType.solar: [
      MonitoringData(timestamp: DateTime(2024, 1, 1), value: 1000),
      MonitoringData(timestamp: DateTime(2024, 1, 2), value: 2000),
    ]
  };

  setUpAll(() {
    registerFallbackValue(MonitoringType.solar);
  });

  group('HomeView', () {
    late HomeBloc bloc;

    setUp(() {
      bloc = MockHomeBloc();

      when(() => bloc.state).thenReturn(
        HomeState(status: HomeStatus.success, monitorings: mockMonitorings),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: bloc,
        child: const HomeView(),
      );
    }

    testWidgets(
      'renders AppBar with title text',
      (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(AppBar), findsOneWidget);

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Monitoring'),
          ),
          findsOneWidget,
        );

        await tester.pumpAndSettle();
      },
    );

    testWidgets('renders correctly initial views', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(MonitoringDatePicker), findsOneWidget);
      expect(find.byType(UnitSwitch), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('toggles unit switch', (tester) async {
      await tester.pumpApp(buildSubject());

      final switchWidget = find.byType(Switch);
      expect(switchWidget, findsOneWidget);

      await tester.tap(switchWidget);
      await tester.pump();

      verify(() => bloc.add(const HomeEventSwitchUnit(isOn: true))).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets('navigates through date picker', (tester) async {
      when(() => bloc.state)
          .thenReturn(HomeState(dateTime: DateTime(2024, 2, 2)));

      await tester.pumpApp(buildSubject());

      final leftButton = find.byIcon(Icons.arrow_left);
      final rightButton = find.byIcon(Icons.arrow_right);

      expect(leftButton, findsOneWidget);
      expect(rightButton, findsOneWidget);

      await tester.tap(leftButton);
      await tester.pump();

      verify(() => bloc.add(const HomeEventTapLeftDatePicker())).called(1);

      await tester.tap(rightButton);
      await tester.pump();

      verify(() => bloc.add(const HomeEventTapRightDatePicker())).called(1);
    });

    testWidgets(
      'renders loading indicator when status is loading',
      (tester) async {
        when(() => bloc.state).thenReturn(
          HomeState(status: HomeStatus.loading, monitorings: const {}),
        );
        await tester.pumpApp(buildSubject());

        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

        await tester.pumpWidget(Container());
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'renders monitoring chart when status is loaded with data; renders monitoring type title; renders unit switch'
      'renders segmented button for monitoring type switching',
      (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(Column), findsOneWidget);
        expect(
            find.descendant(
              of: find.byType(Column),
              matching: find.byType(MonitoringChart),
            ),
            findsOneWidget);
        expect(
            find.descendant(
              of: find.byType(Column),
              matching: find.byType(Text),
            ),
            findsNWidgets(3));
        expect(
            find.descendant(
              of: find.byType(Column),
              matching: find.byType(UnitSwitch),
            ),
            findsOneWidget);

        expect(
            find.descendant(
              of: find.byType(Column),
              matching: find.byType(MonitoringTabs),
            ),
            findsOneWidget);
        expect(find.text('Solar Generation'), findsOneWidget);

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'renders error snackbar when data fetch fails',
      (tester) async {
        whenListen<HomeState>(
          bloc,
          Stream.fromIterable([
            HomeState(),
            HomeState(
              status: HomeStatus.failure,
            ),
          ]),
        );

        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(Constants.defaultErrorMessage),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
