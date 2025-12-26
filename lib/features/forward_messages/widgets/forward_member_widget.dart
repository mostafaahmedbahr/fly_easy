import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/custom_network_image.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';

class ForwardMemberWidget extends StatefulWidget {
  const ForwardMemberWidget({super.key, required this.member,  this.contact,  this.index});
  final MemberModel member;
  final Contact? contact;
  final int? index;
  @override
  State<ForwardMemberWidget> createState() => _ForwardMemberWidgetState();
}

class _ForwardMemberWidgetState extends State<ForwardMemberWidget> {
  ForwardMessageCubit get cubit=>ForwardMessageCubit.get(context);
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected=cubit.selectedMembers.contains(widget.member);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForwardMessageCubit,ForwardMessageState>(
      listenWhen: (previous, current) => current is SelectAllMembers,
      listener: (context, state) {
        if(cubit.allMembersSelected){
          isSelected=true;
        }else{
          isSelected=false;
        }
      },
      buildWhen: (previous, current) => current is SelectAllMembers,
      builder: (context, state) =>  Container(
        decoration: BoxDecoration(
            color: isSelected
                ? AppColors.lightPrimaryColor.withOpacity(.3)
                : Colors.transparent),
        child: ListTile(
          onTap: _onSelect,
          leading: CustomNetworkImage(imageUrl: widget.member.image, width: 40.w),
          title: Text(
            widget.contact?.displayName ?? widget.member.name,
          ),
          enableFeedback: true,
          enabled: true,
        ),
      ),
    );
  }

  void _onSelect() {
    if(isSelected){
      cubit.unSelectMember(widget.member);
    }else {
      cubit.selectMember(widget.member);
    }
    setState(() {
      isSelected = !isSelected;
    });
  }
}
