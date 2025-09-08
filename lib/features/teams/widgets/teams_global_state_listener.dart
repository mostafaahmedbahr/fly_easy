import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';

class TeamsGlobalStateListener extends StatelessWidget {
  const TeamsGlobalStateListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalAppCubit,GlobalAppState>(
      listenWhen: (previous, current) =>
      current is RefreshTeamsAfterAdd ||
          current is RefreshTeamsAfterUpdate,
      listener: (context, state) => context.read<TeamsCubit>().adminTeamsPagingController.refresh(),
      child: const SizedBox.shrink(),
    );
  }
}
