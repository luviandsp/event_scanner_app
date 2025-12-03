import 'package:event_scanner_app/data/models/ticket_data.dart';
import 'package:event_scanner_app/ui/pages/scanner_pages/scanner_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class MyQRPage extends StatelessWidget {
  final Participant participant;

  const MyQRPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    // Logika UI sederhana
    final bool isTicketActive = participant.status == 'ready';

    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: const Text("My Ticket"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black, 
          fontSize: 20, 
          fontWeight: FontWeight.bold
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- KARTU TIKET ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. HEADER: Foto & Nama
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Foto User
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(participant.imageUrl),
                              onBackgroundImageError: (_, __) {},
                              child: participant.imageUrl.isEmpty 
                                ? const Icon(Icons.person, color: Colors.grey) 
                                : null,
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Info Nama & Email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  participant.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  participant.email, // Menampilkan email/info tambahan
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 2. QR CODE
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: QrImageView(
                        data: participant.ticketCode,
                        version: QrVersions.auto,
                        size: 220.0,
                        foregroundColor: isTicketActive ? Colors.black : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 10),
                    
                    // Indikator status kecil di bawah QR (Opsional)
                    Text(
                      isTicketActive ? "Ready to Scan" : "Already Used",
                      style: TextStyle(
                        color: isTicketActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- TOMBOL KE SCANNER ---
           
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigasi yang benar ke halaman Scanner
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScannerQrPage()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
                  label: const Text(
                    "Scan QR Code",
                    style: TextStyle(
                      color: Colors.blueAccent, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueAccent, width: 2), // Outline biru
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent, // Transparan
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}