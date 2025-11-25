class Participant {
  final String id;
  final String name;
  final String email;
  final String ticketCode;
  final String date;
  final String imageUrl;
  String status;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.ticketCode,
    required this.date,
    required this.imageUrl,
    required this.status,
  });
}
