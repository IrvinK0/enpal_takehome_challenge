import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:enpal/core/constants/constants.dart';
import 'package:enpal/core/theme/colors.dart';
import 'package:enpal/domain/models/monitoring_data.dart';
import 'package:enpal/domain/models/monitoring_type.dart';
import 'package:enpal/core/helpers/datetime.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/timer/polling_timer.dart';
import '../../../domain/repositories/monitoring_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

// Constant definitions
const _debounceDuration =
    Duration(milliseconds: 300); // Debounce interval for input events.
const _poolingInterval = Duration(seconds: 30); // Interval for polling updates.

/// A helper function to debounce events. Ensures that consecutive events
/// triggered within a given duration are processed only once.
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

/// [HomeBloc] manages the business logic for the home monitoring feature.
///
/// It is responsible for handling different events related to monitoring data
/// and updating the app's state based on those events.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Constructor to initialize the bloc with a required [MonitoringRepository].
  ///
  /// The [MonitoringRepository] is used to fetch and refresh monitoring data.
  /// A [PoolingTimer] is initialized for managing periodic polling updates.
  /// An optional [DateTime] for [HomeState] inititalization.
  HomeBloc(
      {required MonitoringRepository monitoringRepository, DateTime? dateTime})
      : _monitoringRepository = monitoringRepository,
        _timer = const PoolingTimer(),
        super(HomeState(dateTime: dateTime)) {
    // Event handlers
    on<HomeEventInitialFetch>(_onInitialFetch);
    on<HomeEventSwitchUnit>(_onUnitSwitch);
    on<HomeEventSwitchMonitoringType>(_onMonitoringTypeSwitch);
    on<HomeEventTapLeftDatePicker>(_onTapLeftDatePicker,
        transformer: debounce(_debounceDuration));
    on<HomeEventTapRightDatePicker>(_onTapRightDatePicker,
        transformer: debounce(_debounceDuration));
    on<HomeEventTapClearCache>(_onTapClearCache);
    on<HomeEventRefresh>(_onMonitoringsRefresh);
    on<HomeEventPoolingTimerTicked>(_onPoolingTimerTicked);
  }

  @override
  Future<void> close() {
    // Cancels the pooling subscription when the bloc is closed
    _poolingSubscription?.cancel();
    return super.close();
  }

  final MonitoringRepository _monitoringRepository;
  final PoolingTimer _timer;
  StreamSubscription<int>?
      _poolingSubscription; // Subscription for pooling updates

  /// Handles the initial fetch of monitoring data when the app starts or
  /// when a fresh data load is triggered.
  ///
  /// This method triggers the polling timer and fetches the initial data from the repository.
  /// Upon successful fetch, the state is updated with the data; otherwise, the state
  /// is set to failure.
  Future<void> _onInitialFetch(
      HomeEventInitialFetch event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));

      // Start the pooling timer and skip the first tick
      _restartPooling(skipFirstTick: true);

      // Fetch monitoring data
      final data = await _getMonitorings();

      emit(state.copyWith(status: HomeStatus.success, monitorings: data));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  /// Handles the event when the unit (kW or W) is switched by the user.
  ///
  /// The unit is toggled between [HomeUnit.kiloWatts] and [HomeUnit.watts].
  void _onUnitSwitch(HomeEventSwitchUnit event, Emitter<HomeState> emit) =>
      emit(state.copyWith(
          unit: event.isOn ? HomeUnit.kiloWatts : HomeUnit.watts));

  /// Handles the event when the monitoring type (e.g., solar) is switched.
  void _onMonitoringTypeSwitch(
          HomeEventSwitchMonitoringType event, Emitter<HomeState> emit) =>
      emit(state.copyWith(monitoringType: event.type));

  /// Handles the event when the user taps on the left date picker.
  ///
  /// Decreases the current date by one day and fetches new monitoring data for that date.
  void _onTapLeftDatePicker(
      HomeEventTapLeftDatePicker event, Emitter<HomeState> emit) async {
    await _updateDateAndFetchMonitorings(emit, -1);
  }

  /// Handles the event when the user taps on the right date picker.
  ///
  /// Increases the current date by one day and fetches new monitoring data for that date.
  void _onTapRightDatePicker(
      HomeEventTapRightDatePicker event, Emitter<HomeState> emit) async {
    await _updateDateAndFetchMonitorings(emit, 1);
  }

  /// Handles the event to clear cached monitoring data from the repository.
  void _onTapClearCache(
          HomeEventTapClearCache event, Emitter<HomeState> emit) =>
      _monitoringRepository.clearData();

  /// Handles the event to manually refresh the monitoring data.
  ///
  /// This method refreshes the monitoring data by calling the repository's refresh method
  /// and updating the state accordingly.
  void _onMonitoringsRefresh(
      HomeEventRefresh event, Emitter<HomeState> emit) async {
    try {
      // Restart the pooling process and fetch new data
      _restartPooling(skipFirstTick: false);
      final data = await _refreshMonitorings();

      emit(state.copyWith(status: HomeStatus.success, monitorings: data));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  /// Handles the event triggered by the polling timer when it ticks.
  ///
  /// This method fetches fresh monitoring data at regular intervals triggered by the polling timer.
  void _onPoolingTimerTicked(
      HomeEventPoolingTimerTicked event, Emitter<HomeState> emit) async {
    try {
      final data = await _refreshMonitorings(); // Fetch fresh data
      emit(state.copyWith(status: HomeStatus.success, monitorings: data));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  /// Fetches the monitoring data for all types from the repository.
  ///
  /// This method creates futures for all monitoring types and waits for them to complete
  /// before returning the data in a map.
  Future<Map<MonitoringType, List<MonitoringData>>> _getMonitorings() async {
    var monitoringFutures = {
      for (var type in MonitoringType.values)
        type: _monitoringRepository.getMonitoringData(
            date: state.dateTime, type: type)
    };

    return _processMonitoringDataFutureResult(monitoringFutures);
  }

  /// Refreshes the monitoring data for all types from the repository.
  ///
  /// This method creates futures for all monitoring types and fetches fresh data
  /// from the repository.
  Future<Map<MonitoringType, List<MonitoringData>>>
      _refreshMonitorings() async {
    var monitoringFutures = {
      for (var type in MonitoringType.values)
        type: _monitoringRepository.refreshMonitoringData(
            date: state.dateTime, type: type)
    };

    return _processMonitoringDataFutureResult(monitoringFutures);
  }

  /// Processes the monitoring data futures and returns the results in a map.
  ///
  /// This method waits for all futures to complete and aggregates the results into
  /// a map of `MonitoringType` to a list of monitoring data.
  Future<Map<MonitoringType, List<MonitoringData>>>
      _processMonitoringDataFutureResult(
          Map<MonitoringType, Future<List<MonitoringData>>> futures) async {
    await Future.wait(futures.values.toList());

    var data = <MonitoringType, List<MonitoringData>>{};
    futures.forEach((k, v) async {
      data[k] = await v;
    });

    return data;
  }

  /// Restarts the polling process based on the provided interval.
  ///
  /// The polling is used to fetch fresh data at regular intervals, with an option
  /// to skip the first tick.
  void _restartPooling({required bool skipFirstTick}) {
    _poolingSubscription?.cancel();
    _poolingSubscription = _timer
        .pooling(duration: _poolingInterval)
        .skip(skipFirstTick ? 1 : 0)
        .listen((_) => add(const HomeEventPoolingTimerTicked()));
  }

  /// Updates the current date and fetches new monitoring data for that date.
  ///
  /// The date is modified by the provided [daysToAdd] (either positive or negative),
  /// and then new data is fetched from the repository.
  Future<void> _updateDateAndFetchMonitorings(
      Emitter<HomeState> emit, int daysToAdd) async {
    emit(state.copyWith(
        status: HomeStatus.loading,
        dateTime: state.dateTime.add(Duration(days: daysToAdd))));

    final data = await _getMonitorings();

    emit(state.copyWith(status: HomeStatus.success, monitorings: data));
  }
}
