import 'package:event_scanner_app/data/models/ticket_data.dart'; // Import Model Participant
import 'package:event_scanner_app/ui/components/scan_result_dialog.dart';
import 'package:event_scanner_app/ui/pages/scanner_pages/myqr_page.dart';
import 'package:event_scanner_app/ui/pages/scanner_pages/scanner_result.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerQrPage extends StatefulWidget {
  const ScannerQrPage({super.key});

  @override
  State<ScannerQrPage> createState() => _ScannerQrPageState();
}

class _ScannerQrPageState extends State<ScannerQrPage> {
  // Controller untuk scanner
  final MobileScannerController controller = MobileScannerController(
    autoStart: true,
    torchEnabled: false,
    facing: CameraFacing.back,
  );

  bool _isScanCompleted = false;
  ScanStatus? status;
  Participant? data = Participant(
    id: "USR-001",
    name: "John Doe",
    email: "john@example.com",
    ticketCode: "090",
    date: "2024-12-12",
    imageUrl: "https://i.pravatar.cc/150?u=1", // Gambar dummy
    status: "ready",
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Fungsi untuk reset scanner (Ditekan saat tombol di Dialog diklik)
  void _resetScanner() {
    setState(() {
      _isScanCompleted = false;
    });
    controller.start();
  }

  // --- LOGIKA UTAMA DI SINI ---
  void _handleBarcode(BarcodeCapture capture) {
    // 1. Cegah double scan
    if (_isScanCompleted) return;

    final String? code = capture.barcodes.first.rawValue;

    if (code != null) {
      // 2. Stop Kamera & Update State
      setState(() {
        _isScanCompleted = true;
      });
      controller.stop(); // Penting: Matikan kamera saat dialog muncul

      // 3. SIMULASI LOGIKA DATABASE (Ganti ini dengan API Call nanti)
      // Kita tentukan status berdasarkan kode QR yang discan untuk testing

      if (code.contains("VALID")) {
        // CASE 1: BERHASIL
        status = ScanStatus.success;
      } else if (code.contains("USED")) {
        // CASE 2: SUDAH DIPAKAI
        status = ScanStatus.alreadyUsed;
        data = Participant(
          id: "USR-999",
          name: "Jane Smith",
          email: "jane@example.com",
          ticketCode: code,
          date: "2024-12-10",
          imageUrl: "https://i.pravatar.cc/150?u=2",
          status: "checked_in",
        );
      } else {
        // CASE 3: TIDAK DITEMUKAN
        status = ScanStatus.notFound;
        data = null;
      }

      // 4. TAMPILKAN DIALOG HASIL
      showDialog(
        context: context,
        barrierDismissible: false, // User tidak bisa tap di luar untuk tutup
        builder: (context) {
          return ScanResultDialog(
            status: status!,
            participant: data,
            onActionPressed: () {
              // Tutup Dialog
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanResultPage(scannedCode: code),
                ),
              );
              // Nyalakan scanner lagi
              _resetScanner();
            },
          );
        },
      );
    }
  }

  // Fungsi Manual Scan (Tombol Rescan)
  void _scanManual() {
    _resetScanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.blue,
        title: Center(
          child: const Text(
            "Scan QR Code",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyQRPage(participant: data!),
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
          //   onPressed: () => controller.toggleTorch(),
          // ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleBarcode, // Panggil fungsi handle barcode di sini
          ),

          // --- Overlay UI (Area Gelap) ---
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

          // Border Scanner Biru
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

          // Tombol Rescan (Muncul jika scanner dihentikan manual atau error)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isScanCompleted ? Colors.red : Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                // Tombol hanya aktif jika scan sudah stop (untuk manual restart)
                onPressed: _isScanCompleted ? _scanManual : null,
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
