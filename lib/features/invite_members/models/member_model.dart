import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final String phone;
  final String email;

  const MemberModel({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      image: json['profile_image'],
      phone: json['phone'],
      email:json['email'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, image, phone,email];
}
