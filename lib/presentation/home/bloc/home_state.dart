part of 'home_bloc.dart';

/// [HomeStatus] represents the status of the HomeState.
enum HomeStatus { loading, success, failure }

/// [HomeUnit]represents the unit of measurement for energy.
/// The values are watts and kiloWatts, each with a descriptive label.
enum HomeUnit {
  watts('W'), // Represents the energy measurement in watts.
  kiloWatts(
      'kW'); // Represents the energy measurement in kilowatts (1 kW = 1000 W).

  final String label;

  /// Constructor for [HomeUnit], initializing the [label] for each unit.
  const HomeUnit(this.label);
}

/// [HomeState] holds the state of the HomeBloc, including the monitoring data,
/// the current unit of measurement, monitoring type, and other information relevant
/// to the home energy monitoring feature.
final class HomeState extends Equatable {
  /// Constructor for initializing the [HomeState] with optional parameters.
  ///
  /// The default values are:
  /// - `status`: [HomeStatus.loading]
  /// - `monitorings`: an empty map.
  /// - `unit`: [HomeUnit.kiloWatts]
  /// - `monitoringType`: [MonitoringType.solar]
  /// - `dateTime`: the current date and time (if not provided).
  HomeState({
    this.status = HomeStatus.loading,
    this.monitorings = const {},
    this.unit = HomeUnit.kiloWatts,
    this.monitoringType = MonitoringType.solar,
    dateTime,
  }) : dateTime = (dateTime ?? DateTime.now());

  final HomeStatus
      status; // The current status of the home monitoring (loading, success, or failure).
  final Map<MonitoringType, List<MonitoringData>>
      monitorings; // The monitoring data grouped by [MonitoringType].
  final HomeUnit
      unit; // The unit of measurement for energy (watts or kiloWatts).
  final MonitoringType
      monitoringType; // The current monitoring type (e.g., solar, house consumption).
  final DateTime dateTime; // The current selected date.

  /// Retrieves an error message if the status is [HomeStatus.failure].
  String? get errorMessage => switch (status) {
        HomeStatus.failure => Constants.defaultErrorMessage,
        _ => null
      };

  /// Returns the title corresponding to the current [monitoringType].
  String get monitoringTitle => switch (monitoringType) {
        MonitoringType.solar => Constants.solarGeneration,
        MonitoringType.house => Constants.houseConsumption,
        MonitoringType.battery => Constants.batteryConsumption
      };

  /// Returns a list of [MonitoringData] that is formatted according to the current [unit].
  /// If the unit is watts, the data is returned as-is. If the unit is kiloWatts, the values
  /// are divided by 1000 to convert to kilowatts.
  List<MonitoringData> get formattedMonitorings => switch (unit) {
        HomeUnit.watts => _activeTypeMonitorings,
        HomeUnit.kiloWatts => _activeTypeMonitorings
            .map((e) => MonitoringData(
                timestamp: e.timestamp,
                value: e.value / 1000)) // Convert values to kiloWatts.
            .toList(),
      };

  /// A private getter to retrieve the list of [MonitoringData] for the currently selected [monitoringType].
  List<MonitoringData> get _activeTypeMonitorings =>
      monitorings[monitoringType] ?? [];

  /// Checks if the current [unit] is set to kiloWatts.
  bool get isKiloUnitOn => unit == HomeUnit.kiloWatts;

  /// Returns the formatted date string for the selected [dateTime] in the format "yyyy-MM-dd".
  String get formattedDate =>
      DateFormat(DateFormat.YEAR_MONTH_DAY).format(dateTime);

  /// Checks if the selected [dateTime] is today's date.
  bool get isPickerAtMaxDate => isToday(dateTime);

  /// Returns the color associated with the selected [monitoringType] for chart visualization.
  Color get chartColor => switch (monitoringType) {
        MonitoringType.solar => LightPallete().solar,
        MonitoringType.house => LightPallete().house,
        MonitoringType.battery => LightPallete().charging,
      };

  /// Creates a copy of the current state with optional overrides for some fields.
  ///
  /// This is useful for creating new states without modifying the original state.
  HomeState copyWith({
    HomeStatus? status,
    Map<MonitoringType, List<MonitoringData>>? monitorings,
    HomeUnit? unit,
    MonitoringType? monitoringType,
    DateTime? dateTime,
  }) {
    return HomeState(
      status: status ?? this.status,
      monitorings: monitorings ?? this.monitorings,
      unit: unit ?? this.unit,
      monitoringType: monitoringType ?? this.monitoringType,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  List<Object> get props => [
        status,
        unit,
        monitoringType,
        monitorings,
        dateTime,
      ];
}
