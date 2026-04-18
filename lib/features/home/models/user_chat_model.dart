class UserChatModel {
  final dynamic id;
  final dynamic userId;
  final dynamic name;
  final dynamic image;
  final dynamic phone;
  final dynamic email;
  final dynamic counter;

  final int newMessagesNum;

  UserChatModel(
      {required this.id,
      required this.image,
        required this.userId,
      required this.phone,
      required this.name,
      required this.email,
      required this.counter,

      required this.newMessagesNum});

  factory UserChatModel.fromJson(Map<String, dynamic> json) => UserChatModel(
      id: json['chat_user_id'],
      userId: json['user_id'],
      name: json['name'],
    newMessagesNum: json['notify_counter'],
      phone: json['phone'],
      image: json['profile_image'],

      email: json['email'],
      counter: json['counter'],
      );
}
