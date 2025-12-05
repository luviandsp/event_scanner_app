import 'package:flutter/material.dart';
import 'package:event_scanner_app/data/models/event_model.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _showTicket = true;
  bool _expandCard = false;

  @override
  Widget build(BuildContext context) {
    final daysRemaining = _calculateDaysRemaining(widget.event.date);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColors.darkGreen,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Arial Rounded MT Bold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Body dengan curved top dan background putih
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Card with image inside
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFB2B0B0),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image with rounded top corners
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Image.network(
                                    widget.event.imageUrl,
                                    width: width - 40,
                                    height: (width - 40) * 0.45,
                                    fit: BoxFit.cover,
                                  ),
                                  // Dark overlay
                                  Container(
                                    width: width - 40,
                                    height: (width - 40) * 0.45,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.0),
                                          Colors.black.withValues(alpha: 0.15),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Title area
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.event.title,
                                    style: const TextStyle(
                                      color: Color(0xFF033737),
                                      fontSize: 28,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tanggal:',
                                            style: TextStyle(
                                              color: CustomColors.darkGreen,
                                              fontSize: 13,
                                              fontFamily: 'Arial',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.event.formattedDate,
                                            style: const TextStyle(
                                              color: Color(0xFF033737),
                                              fontSize: 12,
                                              fontFamily: 'Arial',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '$daysRemaining Days Remaining!',
                                        style: const TextStyle(
                                          color: Color(0xFF033737),
                                          fontSize: 12,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Ticket stub separator line
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: CustomPaint(
                                size: Size(width - 72, 1),
                                painter: DashedLinePainter(),
                              ),
                            ),
                            // Expanded details section
                            if (_expandCard) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Deskripsi
                                    Text(
                                      'Deskripsi:',
                                      style: TextStyle(
                                        color: CustomColors.darkGreen,
                                        fontSize: 14,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.event.description ?? 'Tidak ada deskripsi',
                                      style: const TextStyle(
                                        color: Color(0xFF033737),
                                        fontSize: 13,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Penyelenggara
                                    Text(
                                      'Penyelenggara:',
                                      style: TextStyle(
                                        color: CustomColors.darkGreen,
                                        fontSize: 14,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.event.organizer ?? 'Tidak ada informasi',
                                      style: const TextStyle(
                                        color: Color(0xFF033737),
                                        fontSize: 13,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Lokasi
                                    Text(
                                      'Lokasi:',
                                      style: TextStyle(
                                        color: CustomColors.darkGreen,
                                        fontSize: 14,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.event.location ?? 'Tidak ada informasi',
                                      style: const TextStyle(
                                        color: Color(0xFF033737),
                                        fontSize: 13,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomPaint(
                                  size: Size(width - 72, 1),
                                  painter: DashedLinePainter(),
                                ),
                              ),
                            ],
                            // Arrow area
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _expandCard = !_expandCard;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: Container(
                                    width: 56,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(
                                      _expandCard ? Icons.expand_less : Icons.expand_more,
                                      color: CustomColors.darkGreen,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tab buttons aligned to left
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Row(
                          children: [
                            _buildTabButton(
                              title: 'Ticket',
                              isSelected: _showTicket,
                              onTap: () {
                                setState(() {
                                  _showTicket = true;
                                });
                              },
                            ),
                            const SizedBox(width: 12),
                            _buildTabButton(
                              title: 'Analysis',
                              isSelected: !_showTicket,
                              onTap: () {
                                setState(() {
                                  _showTicket = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Ticket type title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ticket type',
                            style: TextStyle(
                              color: CustomColors.darkGreen,
                              fontSize: 24,
                              fontFamily: 'Arial Rounded MT Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Ticket cards
                      _showTicket
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _buildTicketTypeCard(
                                    title: 'Regular',
                                    total: 500,
                                    available: 102,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTicketTypeCard(
                                    title: 'Regular Plus',
                                    total: 500,
                                    available: 102,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTicketTypeCard(
                                    title: 'VIP',
                                    total: 500,
                                    available: 102,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTicketTypeCard(
                                    title: 'VIP Plus',
                                    total: 500,
                                    available: 102,
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.lightGreen : Colors.transparent,
          border: Border.all(
            color: CustomColors.lightGreen,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : CustomColors.lightGreen,
            fontSize: 14,
            fontFamily: 'Arial Rounded MT Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTicketTypeCard({
    required String title,
    required int total,
    required int available,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        border: Border.all(
          color: const Color(0xFFB2B0B0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: CustomColors.darkGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.confirmation_number,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF033737),
                    fontSize: 16,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: $total',
                  style: const TextStyle(
                    color: Color(0xFF033737),
                    fontSize: 13,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Available: $available',
                style: const TextStyle(
                  color: Color(0xFF033737),
                  fontSize: 13,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 32,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.yellow,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Check',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Arial Rounded MT Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateDaysRemaining(DateTime eventDate) {
    final now = DateTime.now();
    final difference = eventDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.grey.shade300;
    paint.strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0, size.width), 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}
