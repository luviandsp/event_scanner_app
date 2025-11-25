import 'package:event_scanner_app/data/models/ticket_data.dart';
import 'package:flutter/material.dart';

class ParticipantCard extends StatelessWidget {
  final Participant participant;

  const ParticipantCard({super.key, required this.participant});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return const Color(0xFF00FF00); // Hijau cerah
      case 'Belum Hadir':
        return const Color(0xFFFFC107); // Kuning/Amber
      case 'Invalid':
        return const Color(0xFFFF0000); // Merah
      default:
        return Colors.grey;
    }
  }
  
  // Helper untuk warna teks tombol
  Color getTextColor(String status) {
      if (status == 'Hadir') return const Color(0xFF003333);
      return Colors.white; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(participant.imageUrl),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.ticketCode,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF003333)),
                ),
                Text(participant.email,
                    style: const TextStyle(fontSize: 12, color: Colors.black87)),
                Text(participant.name,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF003333),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                
                // Row bawah: Tanggal dan Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      participant.date,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(participant.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        participant.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: participant.status == 'Hadir' ? Colors.black : Colors.white, // Menyesuaikan kontras
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
