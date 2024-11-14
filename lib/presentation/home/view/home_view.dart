import 'package:enpal/presentation/home/home.dart';
import 'package:enpal/presentation/home/widgets/monitoring_date_picker.dart';
import 'package:enpal/presentation/home/widgets/monitoring_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/monitoring_chart.dart';
import '../widgets/unit_switch.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring'),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor:
                Theme.of(context).scaffoldBackgroundColor),
        actions: [
          TextButton(
              onPressed: () =>
                  context.read<HomeBloc>().add(const HomeEventTapClearCache()),
              child: const Text('CLEAR CACHE'))
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == HomeStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _monitoringWidget(context),
        ),
      ),
    );
  }

  Widget _monitoringWidget(BuildContext context) => RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const HomeEventRefresh());
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    MonitoringDatePicker(
                      text: context
                          .select((HomeBloc bloc) => bloc.state.formattedDate),
                      didTapLeft: () => context
                          .read<HomeBloc>()
                          .add(const HomeEventTapLeftDatePicker()),
                      didTapRight: () => context
                          .read<HomeBloc>()
                          .add(const HomeEventTapRightDatePicker()),
                      isRightButtonEnabled: context.select(
                          (HomeBloc bloc) => !bloc.state.isPickerAtMaxDate),
                    ),
                    UnitSwitch(
                      isOn: context
                          .select((HomeBloc bloc) => bloc.state.isKiloUnitOn),
                      onChanged: (newValue) => context
                          .read<HomeBloc>()
                          .add(HomeEventSwitchUnit(isOn: newValue)),
                    ),
                    Text(context
                        .select((HomeBloc bloc) => bloc.state.monitoringTitle)),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) => switch (state.status) {
                        HomeStatus.loading => const SizedBox(
                            height: 200,
                            child: Center(child: CupertinoActivityIndicator())),
                        HomeStatus.success => MonitoringChart(
                            yLabel: state.unit.label,
                            data: state.formattedMonitorings,
                            lineColor: state.chartColor,
                          ),
                        HomeStatus.failure => Container(),
                      },
                    ),
                    const Spacer(),
                    MonitoringTabs(
                      type: context
                          .select((HomeBloc bloc) => bloc.state.monitoringType),
                      onChanged: (newValue) => context
                          .read<HomeBloc>()
                          .add(HomeEventSwitchMonitoringType(type: newValue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
