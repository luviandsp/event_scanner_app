import 'package:flutter/material.dart';
import 'package:event_scanner_app/data/models/event_model.dart';

class EventListItem extends StatelessWidget {
  final Event event;
  final VoidCallback onDetailTap;

  const EventListItem({
    super.key,
    required this.event,
    required this.onDetailTap,
  });

  int get daysRemaining {
    final now = DateTime.now();
    final difference = event.date.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB2B0B0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 150,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: Color(0xFF033737),
                          fontSize: 28,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Date
                      Text(
                        event.formattedDate,
                        style: const TextStyle(
                          color: Color(0xFF033737),
                          fontSize: 18,
                          fontFamily: 'Arial',
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Days Remaining
                      Text(
                        '$daysRemaining Days Remaining!',
                        style: const TextStyle(
                          color: Color(0xFF033737),
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Detail Button
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 110,
              height: 38,
              child: ElevatedButton(
                onPressed: onDetailTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB501),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Detail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Arial Rounded MT Bold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
