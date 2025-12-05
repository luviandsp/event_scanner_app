import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:event_scanner_app/data/models/mock_ticket_data.dart';
import 'package:intl/intl.dart'; // Jangan lupa add intl untuk format Rupiah

Future<List<int>> generateCheckInReceipt(MockTicketData data) async {
  final profile = await CapabilityProfile.load();
  // Sesuaikan ukuran kertas: mm58 atau mm80
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];

  // Helper untuk format Rupiah
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // --- 1. HEADER ---
  bytes += generator.reset();
  bytes += generator.text(
    'EVENT SCANNER',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2, // Font agak besar
      width: PosTextSize.size2,
    ),
  );
  bytes += generator.text(
    'BUKTI CHECK-IN',
    styles: const PosStyles(align: PosAlign.center, bold: true),
  );
  bytes += generator.feed(1);

  // Tanggal & Jam Check-in
  bytes += generator.text(
    DateFormat('dd-MM-yyyy HH:mm').format(data.checkInTime),
    styles: const PosStyles(align: PosAlign.center),
  );
  bytes += generator.hr(); // Garis pemisah

  // --- 2. INFORMASI TIKET (Sesuai Gambar) ---

  // Nama Tiket
  bytes += generator.text('Nama Tiket:', styles: const PosStyles(bold: true));
  bytes += generator.text(data.ticketName);
  bytes += generator.feed(1);

  // Kategori
  bytes += generator.row([
    PosColumn(text: 'Kategori', width: 6),
    PosColumn(
      text: data.category,
      width: 6,
      styles: const PosStyles(align: PosAlign.right, bold: true),
    ),
  ]);

  // Jenis Pembayaran
  bytes += generator.row([
    PosColumn(text: 'Tipe Bayar', width: 6),
    PosColumn(
      text: data.paymentType,
      width: 6,
      styles: const PosStyles(align: PosAlign.right),
    ),
  ]);

  // Harga (Hanya muncul jika berbayar/harga > 0)
  if (data.price > 0) {
    bytes += generator.row([
      PosColumn(text: 'Harga', width: 5),
      PosColumn(
        text: currencyFormatter.format(data.price),
        width: 7,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
  }

  bytes += generator.hr();

  // --- 3. STATUS VALIDASI ---
  bytes += generator.text(
    'STATUS: VALID / MASUK',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2, // Font besar untuk status
    ),
  );

  // Deskripsi (Opsional, jika ada)
  if (data.description.isNotEmpty) {
    bytes += generator.feed(1);
    bytes += generator.text(
      'Catatan:',
      styles: const PosStyles(underline: true),
    );
    bytes += generator.text(data.description);
  }

  bytes += generator.feed(1);

  // --- 4. QR CODE (Untuk Scan Keluar/Verifikasi Ulang) ---
  bytes += generator.qrcode(data.bookingId, size: QRSize.size4);
  bytes += generator.text(
    data.bookingId,
    styles: const PosStyles(align: PosAlign.center),
  );

  // --- 5. FOOTER ---
  bytes += generator.feed(2);
  bytes += generator.text(
    'Terima kasih telah berkunjung!',
    styles: const PosStyles(align: PosAlign.center),
  );
  bytes += generator.cut();

  return bytes;
}
