import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class ForwardTeamWidget extends StatefulWidget {
  const ForwardTeamWidget({Key? key,required this.team}) : super(key: key);
final TeamModel team;
  @override
  State<ForwardTeamWidget> createState() => _ForwardTeamWidgetState();
}

class _ForwardTeamWidgetState extends State<ForwardTeamWidget> {
  ForwardMessageCubit get cubit=>ForwardMessageCubit.get(context);
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected=cubit.selectedTeams.contains(widget.team);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForwardMessageCubit,ForwardMessageState>(
      listenWhen: (previous, current) => current is SelectAllTeams ,
      listener: (context, state) {
        if(state is SelectAllTeams){
          isSelected=state.selected;
        }
      },
      buildWhen: (previous, current) => current is SelectAllTeams,
      builder: (context, state) =>  Container(
        decoration: BoxDecoration(
            color: isSelected
                ? AppColors.lightPrimaryColor.withOpacity(.3)
                : Colors.transparent),
        child: ListTile(
          onTap: _onSelect,
          leading: CircleNetworkImage(imageUrl: widget.team.image, width: 40.w),
          title: Text(
            widget.team.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          enableFeedback: true,
          enabled: true,
        ),
      ),
    );
  }

  void _onSelect() {
    if(isSelected){
      setState(() {
        isSelected = !isSelected;
      });
      cubit.unSelectTeam(widget.team);
    }else {
      setState(() {
        isSelected = !isSelected;
      });
      cubit.selectTeam(widget.team);
    }

  }
}
