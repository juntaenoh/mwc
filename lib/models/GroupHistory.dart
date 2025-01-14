class GroupHistory {
  String firstName;
  String lastName;
  String category;
  String shortDescription;
  String longDescription;
  String date;
  String time;

  GroupHistory({
    required this.firstName,
    required this.lastName,
    required this.category,
    required this.shortDescription,
    required this.longDescription,
    required this.date,
    required this.time,
  });

  factory GroupHistory.fromJson(Map<String, dynamic> json) {
    return GroupHistory(
      firstName: json['firstName'],
      lastName: json['lastName'],
      category: json['category'],
      shortDescription: json['shortDescription'],
      longDescription: json['longDescription'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'category': category,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'date': date,
      'time': time,
    };
  }

  @override
  String toString() {
    return 'History(firstName: $firstName, lastName: $lastName, category: $category, shortDescription: $shortDescription, longDescription: $longDescription, date: $date, time: $time)';
  }
}
