import 'package:equatable/equatable.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';

class InviteIdentifier extends Equatable{
  final AddChannelCubit addChannelCubit;
  final bool isModeratorSelection;

  const InviteIdentifier({
    required this.addChannelCubit,
    required this.isModeratorSelection
});

  @override
  List<Object?> get props => [addChannelCubit,isModeratorSelection];
}