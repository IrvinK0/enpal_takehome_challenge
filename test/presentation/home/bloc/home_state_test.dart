import 'package:enpal/core/constants/constants.dart';
import 'package:enpal/core/theme/colors.dart';
import 'package:enpal/domain/models/models.dart';
import 'package:enpal/presentation/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    test('copyWith should correctly copy and override fields', () {
      final initialState = HomeState(
        status: HomeStatus.loading,
        monitorings: const {MonitoringType.solar: []},
        unit: HomeUnit.watts,
        monitoringType: MonitoringType.solar,
        dateTime: DateTime(2024, 11, 14),
      );

      final newState = initialState.copyWith(
        status: HomeStatus.success,
        unit: HomeUnit.kiloWatts,
        dateTime: DateTime(2024, 11, 15),
      );

      expect(newState.status, HomeStatus.success);
      expect(newState.unit, HomeUnit.kiloWatts);
      expect(newState.dateTime, DateTime(2024, 11, 15));
      expect(newState.monitorings, initialState.monitorings);
    });

    test('errorMessage should return default error message on failure', () {
      final state = HomeState(status: HomeStatus.failure);
      expect(state.errorMessage, Constants.defaultErrorMessage);

      final stateSuccess = HomeState(status: HomeStatus.success);
      expect(stateSuccess.errorMessage, isNull);
    });

    test(
        'monitoringTitle should return correct titles for each monitoring type',
        () {
      final state = HomeState(monitoringType: MonitoringType.solar);
      expect(state.monitoringTitle, Constants.solarGeneration);

      final stateHouse = HomeState(monitoringType: MonitoringType.house);
      expect(stateHouse.monitoringTitle, Constants.houseConsumption);

      final stateBattery = HomeState(monitoringType: MonitoringType.battery);
      expect(stateBattery.monitoringTitle, Constants.batteryConsumption);
    });

    test('chartColor should return correct colors for each monitoring type',
        () {
      final stateSolar = HomeState(monitoringType: MonitoringType.solar);
      expect(stateSolar.chartColor, LightPallete().solar);

      final stateHouse = HomeState(monitoringType: MonitoringType.house);
      expect(stateHouse.chartColor, LightPallete().house);

      final stateBattery = HomeState(monitoringType: MonitoringType.battery);
      expect(stateBattery.chartColor, LightPallete().charging);
    });

    test('isKiloUnitOn should correctly detect kiloWatts unit', () {
      final stateWatts = HomeState(unit: HomeUnit.watts);
      expect(stateWatts.isKiloUnitOn, isFalse);

      final stateKiloWatts = HomeState(unit: HomeUnit.kiloWatts);
      expect(stateKiloWatts.isKiloUnitOn, isTrue);
    });

    test('formattedDate should return correct formatted date', () {
      final date = DateTime(2024, 11, 14);
      final state = HomeState(dateTime: date);
      expect(state.formattedDate, 'November 14, 2024');
    });

    test('isPickerAtMaxDate should return true for today', () {
      final today = DateTime.now();
      final state = HomeState(dateTime: today);
      expect(state.isPickerAtMaxDate, isTrue);

      final pastDate = DateTime(2024, 11, 10);
      final stateFuture = HomeState(dateTime: pastDate);
      expect(stateFuture.isPickerAtMaxDate, isFalse);
    });
  });
}
