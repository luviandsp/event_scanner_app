import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_scanner_app/view_model/event_viewmodel.dart';
import 'package:event_scanner_app/data/models/event_model.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _carouselIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onCarouselScroll);
  }

  void _onCarouselScroll() {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 60) / 2;
    final scrollOffset = _scrollController.offset;
    final index = (scrollOffset / (cardWidth + 15)).toInt();

    if (mounted && _carouselIndex != index) {
      setState(() {
        _carouselIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onCarouselScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading && viewModel.allEvents.isEmpty) {
          return _buildLoadingState();
        }

        if (viewModel.hasError() && viewModel.allEvents.isEmpty) {
          return _buildErrorState(viewModel);
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              if (viewModel.hasError()) _buildErrorBanner(viewModel),
              if (viewModel.upcomingEvents.isNotEmpty)
                _buildCarouselSection(viewModel),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Event List',
                    style: TextStyle(
                      color: CustomColors.darkGreen,
                      fontSize: 50,
                      fontFamily: 'Arial Rounded MT Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildSearchBarSection(viewModel),

              const SizedBox(height: 20),
              if (viewModel.filteredEvents.isEmpty &&
                  viewModel.searchQuery.isEmpty &&
                  viewModel.allEvents.isEmpty)
                _buildEmptyState()
              else if (viewModel.filteredEvents.isEmpty &&
                  viewModel.searchQuery.isNotEmpty)
                _buildNoSearchResults()
              else
                _buildEventListSection(viewModel),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                color: CustomColors.lightGreen,
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Events...',
              style: TextStyle(
                color: CustomColors.darkGreen,
                fontSize: 18,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(EventViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: CustomColors.darkGreen,
                fontSize: 20,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),
            Text(
              viewModel.errorMessage ?? 'Failed to load events',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontFamily: 'Arial',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => viewModel.refreshEvents(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Try Again',
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
    );
  }

  Widget _buildErrorBanner(EventViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red[400], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              viewModel.errorMessage ?? 'An error occurred',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 13,
                fontFamily: 'Arial',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => viewModel.refreshEvents(),
            child: Icon(Icons.refresh, color: Colors.red[400], size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No Events Available',
              style: TextStyle(
                color: CustomColors.darkGreen,
                fontSize: 18,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new events',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'No Results Found',
              style: TextStyle(
                color: CustomColors.darkGreen,
                fontSize: 18,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSection(EventViewModel viewModel) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 60) / 2;

    return Column(
      children: [
        SizedBox(
          height: 310,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: viewModel.upcomingEvents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: cardWidth,
                  child: _buildCarouselCard(
                    viewModel.upcomingEvents[index],
                    () => viewModel.navigateToDetail(
                      context,
                      viewModel.upcomingEvents[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            viewModel.upcomingEvents.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: _carouselIndex == index ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: _carouselIndex == index
                    ? CustomColors.lightGreen
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(Event event, VoidCallback onDetailTap) {
    int daysRemaining = _calculateDaysRemaining(event.date);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB2B0B0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image as centered box in the middle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: const Color(0xFFB2B0B0), width: 1.5),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Color(0xFF033737),
                      fontSize: 16,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),
                  Text(
                    event.formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF033737),
                      fontSize: 12,
                      fontFamily: 'Arial',
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    '$daysRemaining Days Remaining!',
                    style: const TextStyle(
                      color: Color(0xFF033737),
                      fontSize: 11,
                      fontFamily: 'Arial',
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onDetailTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB501),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Detail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Arial Rounded MT Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarSection(EventViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CustomColors.darkGreen, width: 2.5),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search..',
            hintStyle: TextStyle(
              color: CustomColors.darkGreen,
              fontSize: 16,
              fontFamily: 'Arial',
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 24),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onChanged: (value) {
            viewModel.searchEvents(value);
          },
        ),
      ),
    );
  }

  Widget _buildEventListSection(EventViewModel viewModel) {
    final events = viewModel.filteredEvents.isEmpty
        ? viewModel.allEvents
        : viewModel.filteredEvents;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildEventListItem(
              events[index],
              () => viewModel.navigateToDetail(context, events[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventListItem(Event event, VoidCallback onDetailTap) {
    int daysRemaining = _calculateDaysRemaining(event.date);

    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB2B0B0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image on the left - centered in card
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 16, 12),
            child: Container(
              width: 110,
              height: 106,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: const Color(0xFFB2B0B0), width: 1.5),
              ),
            ),
          ),

          // Content in the middle
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Color(0xFF033737),
                      fontSize: 15,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    event.formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF033737),
                      fontSize: 12,
                      fontFamily: 'Arial',
                    ),
                  ),

                  Text(
                    '$daysRemaining Days Remaining!',
                    style: const TextStyle(
                      color: Color(0xFF033737),
                      fontSize: 11,
                      fontFamily: 'Arial',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side: Icon on top, Button on bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.schedule,
                    color: const Color(0xFF033737),
                    size: 30,
                  ),
                ),

                const SizedBox(height: 35),

                // Detail button on bottom right
                SizedBox(
                  width: 60,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: onDetailTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB501),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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

  int _calculateDaysRemaining(DateTime eventDate) {
    final now = DateTime.now();
    final difference = eventDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}
