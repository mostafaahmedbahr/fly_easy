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
   required   this.phone,
   required this.email,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      image: json['profile_image'] ?? "No Image",
      phone: json['phone'] ?? 'No phone',
      email: json['email'] ?? 'No Email',
    );
  }

  @override
  List<Object?> get props => [id, name, image, phone, email];
}