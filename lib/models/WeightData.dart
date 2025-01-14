class WeightData {
  String weightId;
  DateTime measuredDate;
  DateTime measuredTime;
  double weight;
  double weightChange;
  String weightType;

  WeightData({
    required this.weightId,
    required this.measuredDate,
    required this.measuredTime,
    required this.weight,
    required this.weightChange,
    required this.weightType,
  });
  String toString() {
    return '{measuredDate: $measuredDate, measuredTime: $measuredTime, weight: $weight, weightType: $weightType,weightChange: $weightChange}';
  }

  factory WeightData.fromJson(Map<String, dynamic> json) {
    return WeightData(
      weightId: json['weightId'],
      measuredDate: DateTime.parse(json['measuredDate']),
      measuredTime: DateTime.parse("${json['measuredDate']} ${json['measuredTime']}"),
      weight: json['weight'].toDouble(),
      weightChange: json['weightChange']?.toDouble() ?? 0,
      weightType: json['weightType'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'weightId': weightId,
      'measuredDate': measuredDate.toIso8601String().split('T')[0],
      'measuredTime': measuredTime.toIso8601String().split('T')[1],
      'weight': weight,
      'weightType': weightType,
      'weightChange': weightChange,
    };
  }
}
