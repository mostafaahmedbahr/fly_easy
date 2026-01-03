class BannersModel {
  final List<dynamic> banners;

  BannersModel({required this.banners});

  factory BannersModel.fromJson(List<dynamic> json) {
    return BannersModel(
      banners: json.map((e) => e.toString()).toList(),
    );
  }

  List<dynamic> toJson() {
    return banners;
  }
}
