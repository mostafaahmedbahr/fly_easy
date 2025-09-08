import 'dart:io';

class ChatRecordModel {
  String? recordUrl;
  String? virtualId;
  File? recordFile;

  ChatRecordModel({
    this.virtualId,
    this.recordFile,
    this.recordUrl,
});
  factory ChatRecordModel.fromJson(Map<String,dynamic>json){
    return ChatRecordModel(
      virtualId: json['id'],
      recordUrl: json['recordUrl'],
    );
  }

  Map<String,dynamic>toJson(){
    return {
      'id':virtualId,
      'recordUrl':recordUrl,
    };
  }
}