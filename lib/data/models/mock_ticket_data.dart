// Model untuk mock data printing
class MockTicketData {
  final String ticketName;      // Dari field "Nama Tiket"
  final String paymentType;     // Dari "Pilih Jenis Pembayaran"
  final int price;              // Dari "Harga"
  final String category;        // Dari "Kategori"
  final String description;     // Dari "Deskripsi"
  final String bookingId;       // ID Unik/Barcode
  final DateTime checkInTime;   // Waktu saat ini

  MockTicketData({
    required this.ticketName,
    required this.paymentType,
    required this.price,
    required this.category,
    required this.description,
    required this.bookingId,
    required this.checkInTime,
  });
}