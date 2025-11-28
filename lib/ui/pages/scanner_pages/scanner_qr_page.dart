import 'package:event_scanner_app/ui/utils/custom_colors.dart'; // Pastikan path ini benar
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Placeholder untuk halaman hasil (jika belum ada)
class ScanResultScreen extends StatelessWidget {
  final String qrData;
  const ScanResultScreen({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Scan")),
      body: Center(child: Text("Data: $qrData")),
    );
  }
}

class ScannerQrPage extends StatefulWidget {
  const ScannerQrPage({super.key});

  @override
  State<ScannerQrPage> createState() => _ScannerQrPageState();
}

class _ScannerQrPageState extends State<ScannerQrPage> {
  // Controller untuk scanner
  final MobileScannerController controller = MobileScannerController(
    // autoStart: true biasanya lebih aman agar kamera langsung nyala saat widget dibuat
    autoStart: true,
    torchEnabled: false,
    facing: CameraFacing.back,
  );

  // Variable untuk mencegah navigasi ganda saat scan berhasil
  // Variable state (Ubah nama sesuai preferensi, misal _isAlreadyScan atau _isScanCompleted)
  bool _isScanCompleted = false;

  // Fungsi untuk melakukan Rescan / Manual Scan
  void _scanManual() {
    setState(() {
      _isScanCompleted = false; // Reset status agar bisa scan lagi
    });
    controller.start(); // Perintah ke library untuk menyalakan kamera kembali
  }

  // Update fungsi onDetect (di dalam MobileScanner)
  void _onDetect(BarcodeCapture capture) {
    if (_isScanCompleted) return; // Cegah double scan

    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      setState(() {
        _isScanCompleted = true; // Tandai sudah selesai
      });
      controller.stop(); // Matikan kamera (hemat baterai)

      // ... Lakukan navigasi atau tampilkan dialog error di sini ...
      // Jika scan "Gagal" (misal tiket tidak valid), user akan melihat tombol Rescan
    }
  }

  @override
  void dispose() {
    // Dispose controller saat halaman ditutup
    controller.dispose();
    super.dispose();
  }

  // Fungsi untuk reset scanner saat kembali dari halaman detail
  void _resetScanner() {
    setState(() {
      _isScanCompleted = false;
    });
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.blue, // Pastikan warna ini ada
        title: const Text(
          "Scan QR Code",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            // onDetect akan terpanggil setiap kali kamera melihat QR
            onDetect: (BarcodeCapture capture) {
              // 1. Cek apakah proses scan sudah selesai sebelumnya
              if (_isScanCompleted) return;

              // 2. Ambil data barcode
              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isNotEmpty) {
                final Barcode firstBarcode = barcodes.first;
                final String? code = firstBarcode.rawValue;

                if (code != null) {
                  // 3. Tandai scan selesai & Stop kamera
                  setState(() {
                    _isScanCompleted = true;
                  });
                  // Opsional: Bunyikan suara beep atau getar di sini

                  // 4. Navigasi ke halaman hasil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanResultScreen(qrData: code),
                    ),
                  ).then((_) {
                    // 5. Restart scanner saat user kembali dari halaman hasil
                    _resetScanner();
                  });
                }
              }
            },
          ),

          // --- Overlay UI (Kotak & Teks) ---

          // Gelapkan area di luar kotak scan (Opsional, agar terlihat pro)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.dstIn,
                  ),
                ),
                Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Border kotak scanner (Garis Biru)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Teks Petunjuk
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                "Arahkan kamera ke QR Code tiket",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0), // Jarak dari bawah
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isScanCompleted
                      ? Colors.red
                      : Colors.blue, // Merah jika stop, Biru jika aktif
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                // PERBAIKAN PENTING: Jangan pakai tanda kurung () di sini
                onPressed: _isScanCompleted ? _scanManual : null,

                // Logika Text:
                // Jika scan selesai/berhenti -> Tampilkan "Rescan"
                // Jika sedang scanning -> Tampilkan "Scanning..." atau sembunyikan
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isScanCompleted ? Icons.refresh : Icons.camera_alt,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isScanCompleted ? 'Rescan' : 'Scanning...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
