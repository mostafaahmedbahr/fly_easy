import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/firebase_services/firebase_keys.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/home/firebase_user_model.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'forward_message_state.dart';

class ForwardMessageCubit extends Cubit<ForwardMessageState> {
  ForwardMessageCubit()
      : super(ForwardMessageInitial());
  // final BaseFirebaseStorageServices _firebaseStorageServices;

  static ForwardMessageCubit get(BuildContext context) =>
      BlocProvider.of<ForwardMessageCubit>(context);

  /// ////////////////////////////////////////////////////
  /// //////////////// Members & Teams Selection /////////
  /// //////////////////////////////////////////////////////

  static const _pageSize = 15;

  String? currentTeamId, currentUserId;

  List<MemberModel> members = [];
  String? usersSearchKey;

  Future<void> getAvailableUsersPaginated(
      PagingController<int, MemberModel> membersPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'ignored_member_id': currentUserId,
          'search': usersSearchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.myContacts, query: queryParameters);
        if (response.statusCode == 200) {
          List<MemberModel> list = [];
          response.data['data'].forEach((team) {
            list.add(MemberModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            membersPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            membersPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        membersPagingController.error = errorMessage;
        emit(ErrorState(errorMessage));
      }
    } else {
      emit(ErrorState(AppStrings.checkInternet));
    }
  }

  Future<void> getAvailableMembers() async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      emit(GetAvailableMembersLoad());
      members = [];
      try {
        final Map<String, dynamic> queryParameters = {
          'ignored_member_id': currentUserId,
          'search': usersSearchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.myContacts, query: queryParameters);
        if (response.statusCode == 200) {
          response.data['data'].forEach((team) {
            members.add(MemberModel.fromJson(team));
          });
          emit(GetAvailableMembersSuccess());
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        emit(GetAvailableMembersError(errorMessage));
      }
    } else {
      emit(GetAvailableMembersError(AppStrings.checkInternet));
    }
  }

  List<TeamModel> myTeams = [];
  String? teamsSearchKey;

  Future<void> getAvailableTeamsPaginated(
      PagingController<int, TeamModel> teamsPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'ignored_channel_id': currentTeamId,
          'search': teamsSearchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.allTeams, query: queryParameters);
        if (response.statusCode == 200) {
          List<TeamModel> list = [];
          response.data['data'].forEach((team) {
            list.add(TeamModel.fromJson(team));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            teamsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            teamsPagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        teamsPagingController.error = errorMessage;
        emit(ErrorState(errorMessage));
      }
    } else {
      emit(ErrorState(AppStrings.checkInternet));
    }
  }

  Future<void> getAvailableTeams() async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      emit(GetAvailableTeamsLoad());
      myTeams = [];
      try {
        final Map<String, dynamic> queryParameters = {
          'ignored_channel_id': currentTeamId,
          'search': teamsSearchKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.allTeams, query: queryParameters);
        if (response.statusCode == 200) {
          response.data['data'].forEach((team) {
            myTeams.add(TeamModel.fromJson(team));
          });
          emit(GetAvailableTeamsSuccess());
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        emit(GetAvailableTeamsError(errorMessage));
      }
    } else {
      emit(GetAvailableTeamsError(AppStrings.checkInternet));
    }
  }

  List<MemberModel> selectedMembers = [];
  List<TeamModel> selectedTeams = [];

  void selectMember(MemberModel member) {
    selectedMembers.add(member);
    emit(SelectMember());
  }

  void unSelectMember(MemberModel member) {
    selectedMembers.removeWhere((element) => element.id == member.id);
    allMembersSelected = false;
    emit(UnSelectMember());
  }

  void selectTeam(TeamModel team) {
    selectedTeams.add(team);
    emit(SelectTeam());
  }

  void unSelectTeam(TeamModel team) {
    selectedTeams.removeWhere((element) => element.id == team.id);
    allTeamsSelected = false;
    emit(UnSelectTeam());
  }

  bool allMembersSelected = false;
  bool allTeamsSelected = false;

  void selectAllMembers() {
    allMembersSelected = true;
    selectedMembers = List.from(members);
    emit(SelectAllMembers(allMembersSelected));
  }

  void unSelectAllMembers() {
    allMembersSelected = false;
    selectedMembers = [];
    emit(SelectAllMembers(allMembersSelected));
  }

  void unSelectAllTeams() {
    allTeamsSelected = false;
    selectedTeams = [];
    emit(SelectAllTeams(allTeamsSelected));
  }

  void selectAllTeams() {
    allTeamsSelected = true;
    selectedTeams = List.from(myTeams);
    emit(SelectAllTeams(allTeamsSelected));
  }

  /// ////////////////////////////////////////////
  /// ///////// Teams Chat //////////////////////
  /// /////////////////////////////////////////
  Future<void> forwardMessageToTeams(List<MessageModel> messages) async {
    try {
      for (var message in messages) {
        MessageModel forwardMessage = message.copyWith(
          senderId: HiveUtils.getUserData()!.id,
          senderName: HiveUtils.getUserData()!.name,
          senderImage: HiveUtils.getUserData()!.image,
          dateTime: Timestamp.now(),
        );
        for (var team in selectedTeams) {
          final doc = FirebaseFirestore.instance
              .collection(FirebaseKeys.teams)
              .doc(team.id.toString())
              .collection(FirebaseKeys.chat)
              .doc();
          doc.set(forwardMessage.toJson(doc.id));
          if (forwardMessage.type == MessageType.image.name ||
              forwardMessage.type == MessageType.video.name) {
            saveTeamMedia(forwardMessage, team.id.toString());
          } else if (forwardMessage.type == MessageType.file.name) {
            saveTeamFiles(forwardMessage, team.id.toString());
          } else if (forwardMessage.type == MessageType.link.name) {
            saveTeamLinks(forwardMessage, team.id.toString());
          }
        }
      }
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  /// /////////////////// external share to teams ////////////////////////
  Future<void> sendMessageToTeams(List<MessageModel> messages) async {
    for (var message in messages) {
      if (message.type == MessageType.image.name) {
        _shareImageToTeams(message);
      } else if (message.type == MessageType.video.name) {
        _shareVideoToTeams(message);
      } else if (message.type == MessageType.text.name ||
          message.type == MessageType.link.name) {
        _shareTextToTeams(message);
      }
    }
  }

  Future<void> _shareImageToTeams(MessageModel message) async {
    try {
      for (var image in message.images!) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${Uri.file(image.file!.path).pathSegments.last}/');
        final task = await ref.putFile(image.file!);
        await task.ref.getDownloadURL().then((value) {
          image.imageUrl = value;
        });
      }
      forwardMessageToTeams([message]);
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> _shareVideoToTeams(MessageModel message) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          'videos/${Uri.file(message.video!.videoFile!.path).pathSegments.last}/');
      final task = await ref.putFile(message.video!.videoFile!);
      await task.ref.getDownloadURL().then((value) {
        message.video!.videoUrl = value;
      });
      forwardMessageToTeams([message]);
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> _shareTextToTeams(MessageModel message) async {
    forwardMessageToTeams([message]);
  }

  /// ///////////////////external share to users //////////////////////

  Future<void> sendMessageToUsers(List<MessageModel> messages) async {
    if (selectedMembers.isNotEmpty) {
      for (var message in messages) {
        if (message.type == MessageType.image.name) {
          _shareImageToUsers(message);
        } else if (message.type == MessageType.video.name) {
          _shareVideoToUsers(message);
        } else if (message.type == MessageType.text.name) {
          _shareTextToUsers(message);
        }
      }
    }
  }

  Future<void> _shareImageToUsers(MessageModel message) async {
    try {
      for (var image in message.images!) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${Uri.file(image.file!.path).pathSegments.last}/');
        final task = await ref.putFile(image.file!);
        await task.ref.getDownloadURL().then((value) {
          image.imageUrl = value;
        });
      }
      forwardMessageToMembers([message]);
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> _shareVideoToUsers(MessageModel message) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          'videos/${Uri.file(message.video!.videoFile!.path).pathSegments.last}/');
      final task = await ref.putFile(message.video!.videoFile!);
      await task.ref.getDownloadURL().then((value) {
        message.video!.videoUrl = value;
      });
      forwardMessageToMembers([message]);
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> _shareTextToUsers(MessageModel message) async {
    forwardMessageToMembers([message]);
  }

  /// ///////////////////////////////////////////////////////////////////////
  Future<void> saveTeamMedia(MessageModel message, String teamId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.media)
          .doc();
      await doc.set(message.toJson(doc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveTeamFiles(MessageModel message, String teamId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.files)
          .doc();
      await doc.set(message.toJson(doc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveTeamLinks(MessageModel message, String teamId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.links)
          .doc();
      await doc.set(message.toJson(doc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  /// ////////////////////////////////////////////
  /// ///////// Users Chat //////////////////////
  /// /////////////////////////////////////////
  Future<void> forwardMessageToMembers(List<MessageModel> messages) async {
    for (var message in messages) {
      MessageModel forwardMessage = message.copyWith(
        senderId: HiveUtils.getUserData()!.id,
        senderName: HiveUtils.getUserData()!.name,
        senderImage: HiveUtils.getUserData()!.image,
        dateTime: Timestamp.now(),
      );
      List<int> membersId = [];
      for (var member in selectedMembers) {
        membersId.add(member.id);
      }
      createUsersChats(membersId);
      sendUserNotification(membersId);
      for (var member in selectedMembers) {
        // if (!(await checkIfUSerHasMyChat(member.id.toString()))) {
        //   createNewFirebaseUserChat(FirebaseUserModel(
        //       id: member.id, name: member.name, image: member.image));
        // }
        final doc = FirebaseFirestore.instance
            .collection(FirebaseKeys.users)
            .doc('${HiveUtils.getUserData()!.id}')
            .collection(FirebaseKeys.chat)
            .doc(member.id.toString())
            .collection(FirebaseKeys.messages)
            .doc();
        doc.set(message.toJson(doc.id));
        final otherDoc = FirebaseFirestore.instance
            .collection(FirebaseKeys.users)
            .doc(member.id.toString())
            .collection(FirebaseKeys.chat)
            .doc('${HiveUtils.getUserData()!.id}')
            .collection(FirebaseKeys.messages)
            .doc();
        otherDoc.set(message.toJson(doc.id));
        if (forwardMessage.type == MessageType.image.name ||
            forwardMessage.type == MessageType.video.name) {
          saveUsersMedia(forwardMessage, member.id.toString());
        } else if (forwardMessage.type == MessageType.file.name) {
          saveUsersFiles(forwardMessage, member.id.toString());
        } else if (forwardMessage.type == MessageType.link.name) {
          saveUsersLinks(forwardMessage, member.id.toString());
        }
      }
    }
  }

  Future<void> saveUsersMedia(MessageModel message, String userId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.media)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.media)
          .doc();
      doc.set(message.toJson(doc.id));
      otherDoc.set(message.toJson(otherDoc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveUsersFiles(MessageModel message, String userId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.files)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.files)
          .doc();
      doc.set(message.toJson(doc.id));
      otherDoc.set(message.toJson(otherDoc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveUsersLinks(MessageModel message, String userId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.links)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.links)
          .doc();
      doc.set(message.toJson(doc.id));
      otherDoc.set(message.toJson(otherDoc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<bool> checkIfUSerHasMyChat(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection(FirebaseKeys.users)
        .doc(userId)
        .collection(FirebaseKeys.chat)
        .doc('${HiveUtils.getUserData()!.id}')
        .get();
    return doc.exists;
  }

  Future<bool> checkIfMeHasUserChat(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection(FirebaseKeys.users)
        .doc('${HiveUtils.getUserData()!.id}')
        .collection(FirebaseKeys.chat)
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<void> createNewFirebaseUserChat(FirebaseUserModel user) async {
    try {
      FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(user.id.toString())
          .set(user.toJson());
      FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(user.id.toString())
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .set(FirebaseUserModel(
                  id: HiveUtils.getUserData()!.id,
                  name: HiveUtils.getUserData()!.name,
                  image: HiveUtils.getUserData()!.image)
              .toJson());
    } catch (error) {}
  }

  Future<void> createUsersChats(List<int> membersId) async {
    try {
      await DioHelper.postData(
          path: EndPoints.forwardMessage,
          data: FormData.fromMap({'who_receive_message[]': membersId}));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendUserNotification(List<int> userIds) async {
    try {
      await DioHelper.postData(
          path: EndPoints.sendUserNotification,
          data: FormData.fromMap(
              {'from': HiveUtils.getUserData()!.id, 'user_ids[]': userIds}));
    } catch (error) {
      rethrow;
    }
  }
}
