import 'package:enpal/domain/repositories/monitoring_repository.dart';
import 'package:enpal/presentation/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        monitoringRepository: context.read<MonitoringRepository>(),
      )..add(const HomeEventInitialFetch()),
      child: const HomeView(),
    );
  }
}
