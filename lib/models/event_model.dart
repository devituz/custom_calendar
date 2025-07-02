/// Event model to represent calendar events
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final Duration duration;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.duration = const Duration(hours: 1),
  });

  /// Create a copy of the event with updated fields
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    Duration? duration,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      duration: duration ?? this.duration,
    );
  }

  /// Convert event to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'duration': duration.inMinutes,
    };
  }

  /// Create event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'],
      duration: Duration(minutes: json['duration']),
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, title: $title, dateTime: $dateTime}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
