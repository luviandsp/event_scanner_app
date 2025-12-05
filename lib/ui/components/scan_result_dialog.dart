import 'package:event_scanner_app/data/models/ticket_data.dart';
import 'package:flutter/material.dart';

// Enum untuk menentukan status hasil scan
enum ScanStatus { success, notFound, alreadyUsed }

class ScanResultDialog extends StatelessWidget {
  final ScanStatus status;
  final Participant? participant; // Null jika status == notFound
  final VoidCallback onActionPressed; // Fungsi ketika tombol ditekan

  const ScanResultDialog({
    super.key,
    required this.status,
    this.participant,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar dialog fit dengan konten
          children: [
            // 1. Header & Animasi
            _buildHeader(),

            const SizedBox(height: 20),

            // 2. Konten Utama (Card Ticket)
            // Jika Not Found, tidak perlu menampilkan detail tiket
            if (status != ScanStatus.notFound) _buildTicketCard(),
            if (status == ScanStatus.notFound)
              const Text(
                "Data tiket tidak ditemukan di sistem.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 24),

            // 3. Tombol Action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: _getStatusColor(),
                      width: 2,
                    ), // Style border sesuai wireframe
                  ),
                  elevation: 0,
                ),
                onPressed: onActionPressed,
                child: Text(
                  _getButtonText(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS & LOGIC ---

  // Menentukan Judul dan Animasi berdasarkan status
  Widget _buildHeader() {
    String lottieUrl;
    String title;
    Color color;

    switch (status) {
      case ScanStatus.success:
        // URL Lottie Animasi Centang Hijau (masih nyari, sementara pake image)
        lottieUrl =
            '';

        title = "Success";
        color = Colors.green;
        break;
      case ScanStatus.alreadyUsed:
        // URL Lottie Warning Kuning
        lottieUrl =
            '';
        title = "Already Used";
        color = Colors.orange;
        break;
      case ScanStatus.notFound:
        // URL Lottie Error Merah
        lottieUrl =
            '';
        title = "Not Found";
        color = Colors.red;
        break;
    }

    return Column(
      children: [
        // Animasi Lottie (Gunakan Lottie.asset jika file sudah didownload)
        SizedBox(
          height: 150,
          // child: Lottie.network(
          //   lottieUrl,
          //   repeat: status != ScanStatus.success,
          // ),
          child: Image.network(
            fit: BoxFit.cover,
            "https://cdn.pixabay.com/photo/2013/07/13/09/50/delete-156119_640.png"
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Kartu Detail Tiket (Sesuai Wireframe)
  Widget _buildTicketCard() {
    if (participant == null) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ), // Kotak Border Hitam
      ),
      child: Column(
        children: [
          // Gambar User (Kotak disilang di wireframe)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black),
            ),
            child: participant!.imageUrl.isNotEmpty
                ? Image.network(participant!.imageUrl, fit: BoxFit.cover)
                : const Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 12),

          // Tipe Tiket
          const Text(
            "Regular", // Bisa diambil dari participant.ticketType jika ada
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Detail Info
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant!.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow("Email", participant!.email),
                _buildInfoRow("Username", participant!.name),

                // Jika already used, tampilkan info tambahan (opsional)
                if (status == ScanStatus.alreadyUsed)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Tiket ini sudah dipakai pada: ${participant!.date}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Baris Info (Label : Value)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, // Lebar tetap agar titik dua sejajar
            child: Text(label, style: const TextStyle(color: Colors.black87)),
          ),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case ScanStatus.success:
        return Colors.black; // Sesuai wireframe tombol hitam/putih
      case ScanStatus.alreadyUsed:
        return Colors.orange;
      case ScanStatus.notFound:
        return Colors.red;
    }
  }

  String _getButtonText() {
    switch (status) {
      case ScanStatus.success:
        return "Continue & Print";
      case ScanStatus.alreadyUsed:
        return "Close & Report";
      case ScanStatus.notFound:
        return "Try Again";
    }
  }
}
