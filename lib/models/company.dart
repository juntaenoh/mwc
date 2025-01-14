class Company {
  String companyId;
  String companyName;
  String mainImageUrl;
  String subImageUrl;
  String companyAddress;
  List<CompanyCategory> companyCategories;
  View view;
  bool open;

  Company({
    required this.companyId,
    required this.companyName,
    required this.mainImageUrl,
    required this.subImageUrl,
    required this.companyAddress,
    required this.companyCategories,
    required this.view,
    required this.open,
  });

  // JSON 데이터를 받아 Company 객체로 변환하는 factory 생성자
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'],
      companyName: json['companyName'],
      mainImageUrl: json['mainImageUrl'],
      subImageUrl: json['subImageUrl'],
      companyAddress: json['companyAddress'],
      companyCategories: (json['companyCategories'] as List).map((i) => CompanyCategory.fromJson(i)).toList(),
      view: View.fromJson(json['view']),
      open: json['open'],
    );
  }

  // Company 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'mainImageUrl': mainImageUrl,
      'subImageUrl': subImageUrl,
      'companyAddress': companyAddress,
      'companyCategories': companyCategories.map((e) => e.toJson()).toList(),
      'view': view.toJson(),
      'open': open,
    };
  }
}

class CompanyCategory {
  String categoryId;
  String category;

  CompanyCategory({
    required this.categoryId,
    required this.category,
  });

  factory CompanyCategory.fromJson(Map<String, dynamic> json) {
    return CompanyCategory(
      categoryId: json['categoryId'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'category': category,
    };
  }
}

class View {
  String viewId;
  int dailyViewCount;
  int totalViewCount;
  int registeredUserCount;
  int targetUserCount;
  double registrationPercentage;

  View({
    required this.viewId,
    required this.dailyViewCount,
    required this.totalViewCount,
    required this.registeredUserCount,
    required this.targetUserCount,
    required this.registrationPercentage,
  });

  factory View.fromJson(Map<String, dynamic> json) {
    return View(
      viewId: json['viewId'],
      dailyViewCount: json['dailyViewCount'],
      totalViewCount: json['totalViewCount'],
      registeredUserCount: json['registeredUserCount'],
      targetUserCount: json['targetUserCount'],
      registrationPercentage: json['registrationPercentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewId': viewId,
      'dailyViewCount': dailyViewCount,
      'totalViewCount': totalViewCount,
      'registeredUserCount': registeredUserCount,
      'targetUserCount': targetUserCount,
      'registrationPercentage': registrationPercentage,
    };
  }
}
