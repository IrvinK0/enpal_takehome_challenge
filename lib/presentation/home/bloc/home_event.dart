part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeEventInitialFetch extends HomeEvent {
  const HomeEventInitialFetch();
}

final class HomeEventSwitchUnit extends HomeEvent {
  const HomeEventSwitchUnit({required this.isOn});

  final bool isOn;
}

final class HomeEventSwitchMonitoringType extends HomeEvent {
  const HomeEventSwitchMonitoringType({required this.type});

  final MonitoringType type;
}

final class HomeEventTapLeftDatePicker extends HomeEvent {
  const HomeEventTapLeftDatePicker();
}

final class HomeEventTapRightDatePicker extends HomeEvent {
  const HomeEventTapRightDatePicker();
}

final class HomeEventTapClearCache extends HomeEvent {
  const HomeEventTapClearCache();
}

final class HomeEventRefresh extends HomeEvent {
  const HomeEventRefresh();
}

final class HomeEventPoolingTimerTicked extends HomeEvent {
  const HomeEventPoolingTimerTicked();
}
