import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/show_case_widget.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/search/bloc/search_cubit.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';
import 'package:iconly/iconly.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchMemberWidget extends StatefulWidget {
  const SearchMemberWidget({super.key, required this.member,required this.index});
  final MemberModel member;
  final int index;

  @override
  State<SearchMemberWidget> createState() => _SearchMemberWidgetState();
}

class _SearchMemberWidgetState extends State<SearchMemberWidget> {
  SearchCubit get cubit => SearchCubit.get(context);
   GlobalKey? _chatIconHint;
   GlobalKey? _emailIconHint;

  @override
  void initState() {
    super.initState();
    _startShowCase();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleNetworkImage(imageUrl: widget.member.image, width: 45.w),
        SizedBox(width: 10.w,),
        // Expanded(
        //   child: Text(
        //     widget.member.name,
        //     style: Theme.of(context).textTheme.titleMedium,
        //   ),
        // ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.member.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 3.h,),
              Text(
                widget.member.phone,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
              )
            ],
          ),
        ),
        CustomShowCase(
          description:AppStrings.personalChatHint,
          caseKey: _chatIconHint,
          child: IconButton(
              onPressed:_goToChat,
              icon: Icon(
                IconlyLight.chat,
                color: Theme.of(context).iconTheme.color,
              )),
        ),
        SizedBox(width: 5.w,),
        CustomShowCase(
          description:AppStrings.sendEmailHint,
          caseKey: _emailIconHint,
          child: IconButton(
              onPressed: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: widget.member.email,
                );
                launchUrl(emailLaunchUri);
              },
              icon: Icon(
                Icons.email_outlined,
                color: Theme.of(context).iconTheme.color,
              )),
        ),
      ],
    );
  }

  void _goToChat() {
    context.push(Routes.chat,
        arg: TeamChatInfoModel(
          id: widget.member.id,
          image: widget.member.image,
          name: widget.member.name,

          isTeam: false,
        ));
  }

  void _startShowCase() {
    if (!CacheUtils.isEmailHintShown()&&widget.index==0){
      _chatIconHint=GlobalKey();
      _emailIconHint=GlobalKey();
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([_chatIconHint!, _emailIconHint!]));
      CacheUtils.setEmailHint();
      CacheUtils.setPersonalChatHint();
    }
  }
}
