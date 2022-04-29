class BookReadInfo {
  int id;
  int _readBookCount = 0;
  double _averageRating = 0.0;

  BookReadInfo({required this.id});

  int get readBookCount => _readBookCount;
  set readBookCount(int value) {
    _readBookCount = value;
  }

  double get averageRating => _averageRating;
  set averageRating(double value) {
    _averageRating = value;
  }

  String get month => '$id월';

  factory BookReadInfo.fromJson(Map<String, dynamic> json) {
    return BookReadInfo(id: json['id'])
      ..readBookCount = json.containsKey('count') ? json['count'] : 0
      ..averageRating = json.containsKey('average') ? json['average'] : 0.0;
  }
}
