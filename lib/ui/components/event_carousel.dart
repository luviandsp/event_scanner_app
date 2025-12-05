import 'package:flutter/material.dart';
import 'package:event_scanner_app/data/models/event_model.dart';

class EventCarousel extends StatefulWidget {
  final List<Event> events;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final Function(Event) onDetailTap;

  const EventCarousel({
    super.key,
    required this.events,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onDetailTap,
  });

  @override
  State<EventCarousel> createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: widget.onPageChanged,
            itemCount: widget.events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: EventCarouselCard(
                  event: widget.events[index],
                  onDetailTap: () => widget.onDetailTap(widget.events[index]),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),

        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.events.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: widget.currentIndex == index ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: widget.currentIndex == index
                    ? const Color(0xFF00ADB0)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EventCarouselCard extends StatelessWidget {
  final Event event;
  final VoidCallback onDetailTap;

  const EventCarouselCard({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.grey[300],
              image: DecorationImage(
                image: NetworkImage(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Color(0xFF033737),
                    fontSize: 22,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                // Date and Days Remaining Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.formattedDate,
                          style: const TextStyle(
                            color: Color(0xFF033737),
                            fontSize: 16,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$daysRemaining Days Remaining!',
                      style: const TextStyle(
                        color: Color(0xFF033737),
                        fontSize: 14,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Detail Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
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
                        fontSize: 16,
                        fontFamily: 'Arial Rounded MT Bold',
                        fontWeight: FontWeight.bold,
                      ),
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
}
