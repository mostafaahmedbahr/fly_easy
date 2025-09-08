import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SeenWidget extends StatefulWidget {
  const SeenWidget(
      {Key? key, required this.messageId, required this.isSeen, this.color})
      : super(key: key);
  final Color? color;
  final String messageId;
  final bool isSeen;

  @override
  State<SeenWidget> createState() => _SeenWidgetState();
}

class _SeenWidgetState extends State<SeenWidget> {
  bool seen = false;

  @override
  void initState() {
    super.initState();
    seen = widget.isSeen;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
          current is UpdateMessageState &&
          current.messageId == widget.messageId,
      listener: (context, state) {
        print('listen////////////////////////');
        if (state is UpdateMessageState) {
          seen = true;
        }
      },
      buildWhen: (previous, current) =>
          current is UpdateMessageState &&
          current.messageId == widget.messageId,
      builder: (context, state) => Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Visibility(
            visible: seen,
            replacement: const SizedBox.shrink(),
            child:  Icon(
              FontAwesomeIcons.checkDouble,
              size: 15,
              color:widget.color??Colors.white,
            )),
      ),
    );
  }
}
