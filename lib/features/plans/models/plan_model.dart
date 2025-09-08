import 'package:equatable/equatable.dart';

class PlanModel extends Equatable {
  final int id;
  final String name;
  final String type;
  final int count;
  final String price;
  final int months;
  final List<LibrarySectionModel>? librarySections;

  const PlanModel({
    required this.name,
    required this.type,
    required this.count,
    required this.id,
    required this.price,
    required this.months,
    required this.librarySections,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    List<LibrarySectionModel> librarySections = [];
    if (json['type'] == 'library') {
      json['library_sections'].forEach((section) {
        librarySections.add(LibrarySectionModel.fromJson(section));
      });
    }
    return PlanModel(
      name: json['name'],
      type: json['type'],
      count: json['count'] ?? 0,
      id: json['id'],
      months: json['num_of_months']??12,
      price: json['price'],
      librarySections: librarySections,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, count, type, price];
}

class LibrarySectionModel {
  final int id;
  final String name;

  LibrarySectionModel({
    required this.id,
    required this.name,
  });

  factory LibrarySectionModel.fromJson(Map<String, dynamic> json) {
    return LibrarySectionModel(id: json['id'], name: json['name']);
  }
}

enum PlanType {team,community,subcommunity,member,library}