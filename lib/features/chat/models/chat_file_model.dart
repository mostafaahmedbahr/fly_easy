import 'dart:io';

class ChatFileModel {
  String? fileUrl;
  File? file;
  String? fileName;
  int? fileSize;
  String? fileExtension;
  String? virtualId;

  ChatFileModel({
    this.file,
    this.fileUrl,
    this.virtualId,
    this.fileName,
    this.fileSize,
    this.fileExtension,
  });

  factory ChatFileModel.fromJson(Map<String, dynamic> json) {
    return ChatFileModel(
        virtualId: json['id'],
        fileName: json['fileName']??json['id'],
        fileSize: json['fileSize'],
        fileExtension: json['fileExtension'],
        fileUrl: json['fileUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': virtualId,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileExtension': fileExtension,
      'fileUrl': fileUrl,
    };
  }
}
