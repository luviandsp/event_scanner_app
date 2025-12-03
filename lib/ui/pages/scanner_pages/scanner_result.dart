import 'package:event_scanner_app/data/models/ticket_data.dart';
import 'package:flutter/material.dart';
// import 'participant_model.dart'; // Pastikan import model Participant
// import 'ticket_service.dart'; // Pastikan import service di atas

class ScanResultPage extends StatefulWidget {
  final String scannedCode;

  const ScanResultPage({super.key, required this.scannedCode});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  // final TicketService _ticketService = TicketService();

  bool _isLoading = true;
  TicketValidationResult? _result;

  @override
  void initState() {
    super.initState();
    // Otomatis jalankan validasi database saat halaman dibuka
    _processTicket();
  }

  final TicketValidationResult result = TicketValidationResult(
    success: true,
    message: "Success",
    data: Participant(
      id: "abc12345",
      name: "Mister",
      email: "Mister@gmail.com",
      ticketCode: "12345",
      date: "2024-12-04",
      imageUrl: "https://i.pravatar.cc/150?u=a042581f4e29026024d",
      status: "checked_in", // Status sudah diperbarui jadi 'Hadir'
    ),
  );

  //dummy untuk nyoba ui
  final Participant data = Participant(
    id: "abc12345",
    name: "Mister",
    email: "Mister@gmail.com",
    ticketCode: "12345",
    date: "2024-12-04",
    imageUrl: "https://i.pravatar.cc/150?u=a042581f4e29026024d",
    status: "checked_in", // Status sudah diperbarui jadi 'Hadir'
  );

  Future<void> _processTicket() async {
    // final result = await _ticketService.validateAndCheckIn(widget.scannedCode);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Tampilan Loading
          : _buildResultContent(),
    );
  }

  Widget _buildResultContent() {
    // Jika Gagal (Data null atau success false)
    if (_result == null || !_result!.success) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 16),
            Text(
              "Failed",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _result?.message ?? "Terjadi kesalahan",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Scan Again"),
            ),
          ],
        ),
      );
    }

    // Jika Sukses (Data tersedia)
    // final Participant data = _result!.data!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Scan QR Code",
            style: TextStyle(fontSize: 24, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          const Text(
            "Success",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 40),

          // --- KOTAK INFO TIKET (Sesuai Wireframe) ---
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ), // Border kotak tebal
            ),
            child: Column(
              children: [
                // Placeholder Image (Silang kotak)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Image.network(
                    data.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback jika gambar error (simulasi kotak silang wireframe)
                      return const Icon(Icons.close, size: 60);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Tipe Tiket
                const Text(
                  "Regular", // Bisa diambil dari data.ticketType jika ada
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 30),

                // Detail Peserta (Kiri rata)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.id, // abc123
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow("Email", data.email),
                      const SizedBox(height: 8),
                      _buildInfoRow("Username", data.name),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // --- TOMBOL AKSI ---
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ), // Kotak tajam sesuai wireframe
              ),
              onPressed: () {
                // Logic Print atau Lanjut
                print("Mencetak tiket untuk ${data.name}");
                Navigator.pop(context); // Kembali ke scanner
              },
              child: const Text(
                "Continue & Print",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper widget untuk baris text
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        const Text(
          ": ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// digabung dulu

class TicketValidationResult {
  final bool success;
  final String message;
  final Participant? data;

  TicketValidationResult({
    required this.success,
    required this.message,
    this.data,
  });
}
