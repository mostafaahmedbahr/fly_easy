import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/file_model.dart';
import 'package:new_fly_easy_new/features/library/models/image_model.dart';
import 'package:new_fly_easy_new/features/library/models/section_model.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:new_fly_easy_new/features/library/screens/views/files_view.dart';
import 'package:new_fly_easy_new/features/library/screens/views/photos_view.dart';
import 'package:new_fly_easy_new/features/library/screens/views/sounds_view.dart';
import 'package:new_fly_easy_new/features/library/screens/views/videos_view.dart';
import 'package:new_fly_easy_new/features/library/widgets/media_tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SectionScreen extends StatefulWidget {
  const SectionScreen({Key? key, required this.section}) : super(key: key);
  final SectionModel section;

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen>
    with SingleTickerProviderStateMixin {
  SectionCubit get cubit=>SectionCubit.get(context);
  late TabController _tabController;
  final PagingController<int, ImageModel> _imagesPagingController =
      PagingController<int, ImageModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, VideoModel> _videosPagingController =
      PagingController<int, VideoModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, FileModel> _filesPagingController =
      PagingController<int, FileModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, SoundModel> _soundsPagingController =
      PagingController<int, SoundModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);

  @override
  void initState() {
    super.initState();
    cubit.sectionId=widget.section.id;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _imagesPagingController.dispose();
    _videosPagingController.dispose();
    _soundsPagingController.dispose();
    _filesPagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SectionCubit,SectionState>(
      listener: (context, state) {
        if(state is ErrorState){
          AppFunctions.showToast(message: state.error, state: ToastStates.error);
        }
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: _appBar(),
            body: Column(
              children: [
                MediaTabBar(tabController: _tabController, tabs: [
                  Text(LocaleKeys.photos.tr()),
                  Text(LocaleKeys.videos.tr()),
                  Text(LocaleKeys.sounds.tr()),
                  Text(LocaleKeys.files.tr())
                ]),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child: TabBarView(controller: _tabController, children: [
                  PhotosView(imagesPagingController: _imagesPagingController),
                  VideosView(videosPagingController: _videosPagingController),
                  SoundsView(soundsPagingController: _soundsPagingController),
                  FilesView(filesPagingController: _filesPagingController),
                ]))
              ],
            ),
          ),

      ),
    );
  }

  /// ///////////////////////////////////////
  /// ///////// methods /////////////////////
  /// ////////////////////////////////////////

  AppBar _appBar() => AppBar(
        title: Text(widget.section.name),
        centerTitle: true,
      );
}
