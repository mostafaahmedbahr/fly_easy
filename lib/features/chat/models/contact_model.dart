import 'package:equatable/equatable.dart';

class ContactModel extends Equatable {
  final String name;
  final String phone;

  const ContactModel({
    required this.name,
    required this.phone,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name,phone];
}
