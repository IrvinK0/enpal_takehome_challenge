import 'package:bloc_test/bloc_test.dart';
import 'package:enpal/domain/models/models.dart';
import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:enpal/presentation/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:api_client/api_client.dart';

class MockMonitorRepository extends Mock implements MonitoringRepository {}

void main() {
  final mockSolarData = [
    MonitoringData(timestamp: DateTime(2024, 1, 1), value: 1000),
  ];
  final mockHouseData = [
    MonitoringData(timestamp: DateTime(2024, 1, 1), value: 3000)
  ];

  final mockBatteryData = [
    MonitoringData(timestamp: DateTime(2024, 1, 1), value: 5000)
  ];

  final mockMonitorings = {
    MonitoringType.solar: mockSolarData,
    MonitoringType.house: mockHouseData,
    MonitoringType.battery: mockBatteryData,
  };

  final mockDate = DateTime.now();

  group('HomeBloc', () {
    late MonitoringRepository repository;

    setUpAll(() {
      registerFallbackValue(MonitoringType.solar);
    });

    setUp(() {
      repository = MockMonitorRepository();
      when(
        () => repository.getMonitoringData(
            date: any(named: 'date'), type: MonitoringType.solar),
      ).thenAnswer((_) async => mockSolarData);
      when(
        () => repository.getMonitoringData(
            date: any(named: 'date'), type: MonitoringType.house),
      ).thenAnswer((_) async => mockHouseData);
      when(
        () => repository.getMonitoringData(
            date: any(named: 'date'), type: MonitoringType.battery),
      ).thenAnswer((_) async => mockBatteryData);

      when(
        () => repository.refreshMonitoringData(
            date: any(named: 'date'), type: MonitoringType.solar),
      ).thenAnswer((_) async => mockSolarData);
      when(
        () => repository.refreshMonitoringData(
            date: any(named: 'date'), type: MonitoringType.house),
      ).thenAnswer((_) async => mockHouseData);
      when(
        () => repository.refreshMonitoringData(
            date: any(named: 'date'), type: MonitoringType.battery),
      ).thenAnswer((_) async => mockBatteryData);

      when(
        () => repository.clearData(),
      ).thenAnswer((_) async => true);
    });

    HomeBloc buildBloc() =>
        HomeBloc(monitoringRepository: repository, dateTime: mockDate);

    test('has correct initial state', () {
      expect(
        HomeBloc(monitoringRepository: repository, dateTime: mockDate).state,
        equals(HomeState(dateTime: mockDate)),
      );
    });

    group('HomeEventInitialFetch', () {
      blocTest<HomeBloc, HomeState>(
        'starts initial fetch',
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeEventInitialFetch()),
        verify: (_) {
          verify(() => repository.getMonitoringData(
              date: any(named: 'date'), type: any(named: 'type'))).called(3);
        },
      );

      blocTest<HomeBloc, HomeState>(
          'emits state with updated status and data'
          'when repository getMonitoringData returns new data',
          build: buildBloc,
          act: (bloc) => bloc.add(const HomeEventInitialFetch()),
          expect: () => [
                HomeState(status: HomeStatus.loading, dateTime: mockDate),
                HomeState(
                  status: HomeStatus.success,
                  monitorings: mockMonitorings,
                  dateTime: mockDate,
                )
              ]);

      blocTest<HomeBloc, HomeState>(
        'emits state with failure status'
        'when repository getTodos throws error',
        setUp: () {
          when(
            () => repository.getMonitoringData(
                date: any(named: 'date'), type: any(named: 'type')),
          ).thenAnswer((_) => Future.error(MonitoringRequestFailure()));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeEventInitialFetch()),
        expect: () => [
          HomeState(status: HomeStatus.loading, dateTime: mockDate),
          HomeState(status: HomeStatus.failure, dateTime: mockDate),
        ],
      );
    });

    group('HomeEventSwitchUnit', () {
      blocTest<HomeBloc, HomeState>(
        'emits state with updated unit when sending HomeEventSwitchUnit event',
        setUp: () {},
        build: buildBloc,
        act: (bloc) {
          bloc.add(const HomeEventSwitchUnit(isOn: false));
          bloc.add(const HomeEventSwitchUnit(isOn: true));
        },
        expect: () => [
          HomeState(unit: HomeUnit.watts, dateTime: mockDate),
          HomeState(unit: HomeUnit.kiloWatts, dateTime: mockDate),
        ],
      );
    });

    group('HomeEventSwitchMonitoringType', () {
      blocTest<HomeBloc, HomeState>(
        'emits state with updated monitoring type when sending HomeEventSwitchHomeEventSwitchMonitoringTypeUnit event',
        setUp: () {},
        build: buildBloc,
        act: (bloc) {
          bloc.add(const HomeEventSwitchMonitoringType(
              type: MonitoringType.battery));
          bloc.add(
              const HomeEventSwitchMonitoringType(type: MonitoringType.solar));
          bloc.add(
              const HomeEventSwitchMonitoringType(type: MonitoringType.house));
        },
        expect: () => [
          HomeState(monitoringType: MonitoringType.battery, dateTime: mockDate),
          HomeState(monitoringType: MonitoringType.solar, dateTime: mockDate),
          HomeState(monitoringType: MonitoringType.house, dateTime: mockDate),
        ],
      );
    });

    group('HomeEventTapLeftDatePicker', () {
      blocTest<HomeBloc, HomeState>(
        'emits state with updated status, datetime and data when sending HomeEventTapLeftDatePicker event',
        setUp: () {},
        build: buildBloc,
        act: (bloc) {
          bloc.add(const HomeEventTapLeftDatePicker());
        },
        wait: const Duration(milliseconds: 300),
        expect: () => [
          HomeState(
            status: HomeStatus.loading,
            dateTime: mockDate.add(const Duration(days: -1)),
          ),
          HomeState(
            status: HomeStatus.success,
            monitorings: mockMonitorings,
            dateTime: mockDate.add(const Duration(days: -1)),
          )
        ],
      );
    });

    group('HomeEventTapRightDatePicker', () {
      blocTest<HomeBloc, HomeState>(
        'emits state with updated status, datetime and data when sending HomeEventTapRightDatePicker event',
        setUp: () {},
        build: buildBloc,
        wait: const Duration(milliseconds: 300),
        act: (bloc) {
          bloc.add(const HomeEventTapRightDatePicker());
        },
        expect: () => [
          HomeState(
            status: HomeStatus.loading,
            dateTime: mockDate.add(const Duration(days: 1)),
          ),
          HomeState(
            status: HomeStatus.success,
            monitorings: mockMonitorings,
            dateTime: mockDate.add(const Duration(days: 1)),
          )
        ],
      );
    });

    group('HomeEventTapClearCache', () {
      blocTest<HomeBloc, HomeState>(
        'clear cache event calls repository',
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeEventTapClearCache()),
        verify: (_) {
          verify(() => repository.clearData()).called(1);
        },
      );
    });

    group('HomeEventRefresh', () {
      blocTest<HomeBloc, HomeState>(
        'emits state with updated status and data when sending HomeEventRefresh event',
        setUp: () {},
        build: buildBloc,
        act: (bloc) {
          bloc.add(const HomeEventRefresh());
        },
        verify: (_) {
          verify(() => repository.refreshMonitoringData(
              date: any(named: 'date'), type: any(named: 'type'))).called(3);
        },
        expect: () => [
          HomeState(
            status: HomeStatus.success,
            monitorings: mockMonitorings,
            dateTime: mockDate,
          )
        ],
      );
    });

    group('HomeEventPoolingTimerTicked', () {
      blocTest<HomeBloc, HomeState>(
        'emits state with updated status and data when sending HomeEventPoolingTimerTicked event',
        setUp: () {},
        build: buildBloc,
        act: (bloc) {
          bloc.add(const HomeEventPoolingTimerTicked());
        },
        verify: (_) {
          verify(() => repository.refreshMonitoringData(
              date: any(named: 'date'), type: any(named: 'type'))).called(3);
        },
        expect: () => [
          HomeState(
            status: HomeStatus.success,
            monitorings: mockMonitorings,
            dateTime: mockDate,
          )
        ],
      );
    });
  });
}
