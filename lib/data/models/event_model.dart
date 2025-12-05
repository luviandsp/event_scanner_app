import 'package:intl/intl.dart';


class Event {
  final String id;
  final String title;
  final DateTime date;
  final String imageUrl;
  final String? description;
  final String? organizer;
  final String? location;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
    this.description,
    this.organizer,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Event',
      date: _parseDate(json['date']),
      imageUrl: json['imageUrl'] as String? ?? 'https://picsum.photos/400/300',
      description: json['description'] as String?,
      organizer: json['organizer'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'description': description,
      'organizer': organizer,
      'location': location,
    };
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now().add(const Duration(days: 30));
    }

    if (dateValue is String) {
      try {
        if (dateValue.contains('T')) {
          return DateTime.parse(dateValue);
        }
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now().add(const Duration(days: 30));
      }
    }

    if (dateValue is DateTime) {
      return dateValue;
    }

    return DateTime.now().add(const Duration(days: 30));
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(date);

  @override
  String toString() => 'Event(id: $id, title: $title, date: $date)';
}