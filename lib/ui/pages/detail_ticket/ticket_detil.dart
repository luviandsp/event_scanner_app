import 'package:event_scanner_app/ui/components/participant_card.dart';
import 'package:event_scanner_app/ui/data/ticket_data.dart';
import 'package:flutter/material.dart';

class TechTalkScreen extends StatefulWidget {
  const TechTalkScreen({super.key});

  @override
  State<TechTalkScreen> createState() => _TechTalkScreenState();
}

class _TechTalkScreenState extends State<TechTalkScreen> {
  // Controller untuk pencarian
  TextEditingController searchController = TextEditingController();

  // Dummy Data (Sesuaikan dengan gambar)
  List<Participant> allParticipants = [
    Participant(
      id: '1',
      name: 'Agung Firmansyah',
      email: 'agung@gmail.com',
      ticketCode: 'Tech - A001',
      date: '20 Oct 2025',
      imageUrl: 'https://picsum.photos/id/1005/200/200', // Placeholder image
      status: 'Hadir',
    ),
    Participant(
      id: '2',
      name: 'Iqbal',
      email: 'iqbal@example.com',
      ticketCode: 'Tech - A002',
      date: '19 Oct 2025',
      imageUrl: 'https://picsum.photos/id/1011/200/200',
      status: 'Belum Hadir',
    ),
    Participant(
      id: '3',
      name: 'Viaan',
      email: 'viann@example.com',
      ticketCode: 'Tech - A003',
      date: '18 Oct 2025',
      imageUrl: 'https://picsum.photos/id/1012/200/200',
      status: 'Invalid',
    ),
  ];

  // List untuk menampung hasil pencarian
  List<Participant> filteredParticipants = [];

  @override
  void initState() {
    super.initState();
    filteredParticipants = allParticipants;
  }

  // Fungsi Pencarian (FR-TKT-003)
  void _runFilter(String enteredKeyword) {
    List<Participant> results = [];
    if (enteredKeyword.isEmpty) {
      results = allParticipants;
    } else {
      results = allParticipants
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user.ticketCode
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.email.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredParticipants = results;
    });
  }

  // Fungsi Ubah Status (FR-TKT-004)
  void _updateStatus(Participant participant, String newStatus) {
    setState(() {
      participant.status = newStatus;
    });
    Navigator.pop(context); // Tutup dialog
  }

  // Widget untuk menampilkan Dialog Ubah Status
  void _showStatusDialog(BuildContext context, Participant participant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Change Status",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003333)),
                ),
                const SizedBox(height: 20),
                // Info User Singkat
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(participant.imageUrl),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            participant.ticketCode,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003333)),
                          ),
                          Text(participant.email,
                              style: const TextStyle(fontSize: 12)),
                          Text(participant.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF003333),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(participant.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 20),
                
                // Pilihan Status Buttons
                _buildStatusButton(participant, "Belum Hadir"),
                const SizedBox(height: 8),
                _buildStatusButton(participant, "Hadir"),
                const SizedBox(height: 8),
                _buildStatusButton(participant, "Invalid"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(Participant participant, String statusLabel) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF003333)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: participant.status == statusLabel
              ? const Color(0xFF003333).withOpacity(0.1)
              : Colors.transparent,
        ),
        onPressed: () => _updateStatus(participant, statusLabel),
        child: Text(
          statusLabel,
          style: const TextStyle(color: Color(0xFF003333)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna tema sesuai gambar
    const Color darkGreen = Color(0xFF003333);
    const Color accentYellow = Color(0xFFFFB300);

    return Scaffold(
      backgroundColor: darkGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text("Tech Talk", style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Bagian Putih Melengkung (Body)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Kartu Tiket
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number,
                              size: 40, color: darkGreen),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Regular",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkGreen)),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total: 500"),
                                    Text("Available: 102"),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Tombol Scan
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika Scan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Scan",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Search Bar (FR-TKT-003)
                    TextField(
                      controller: searchController,
                      onChanged: (value) => _runFilter(value),
                      decoration: InputDecoration(
                        hintText: 'Search..', // atau Tech - A001
                        suffixIcon: const Icon(Icons.search),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: darkGreen),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: darkGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. List Header
                    const Text(
                      "Participant",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: darkGreen),
                    ),
                    const SizedBox(height: 10),

                    // 5. List Peserta
                    Expanded(
                      child: filteredParticipants.isEmpty
                          ? const Center(child: Text('No participants found'))
                          : ListView.builder(
                              itemCount: filteredParticipants.length,
                              itemBuilder: (context, index) {
                                final participant = filteredParticipants[index];
                                return GestureDetector(
                                  onTap: () => _showStatusDialog(
                                      context, participant),
                                  child: ParticipantCard(
                                      participant: participant),
                                );
                              },
                            ),
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


