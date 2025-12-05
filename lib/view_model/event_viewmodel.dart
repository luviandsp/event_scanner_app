import 'package:flutter/material.dart';
import '../data/models/event_model.dart';
import '../data/repositories/event_repository.dart';
import '../ui/pages/event_ticket_pages/event_detail_page.dart';

class EventViewModel extends ChangeNotifier {
  final EventRepository _repository = EventRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Event> _upcomingEvents = [];
  List<Event> get upcomingEvents => _upcomingEvents;

  List<Event> _allEvents = [];
  List<Event> get allEvents => _allEvents;

  List<Event> _filteredEvents = [];
  List<Event> get filteredEvents =>
      _filteredEvents.isEmpty ? _allEvents : _filteredEvents;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  EventViewModel() {
    fetchEvents();
  }
  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final events = await _repository.fetchEvents();
      _upcomingEvents = events.take(4).toList();
      _allEvents = events;
      _filteredEvents = [];
      _errorMessage = null;
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _upcomingEvents = [];
      _allEvents = [];
      _filteredEvents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Event?> fetchEventById(String id) async {
    try {
      final event = await _repository.fetchEventById(id);
      return event;
    } catch (e) {
      _errorMessage = 'Failed to load event details';
      notifyListeners();
      return null;
    }
  }

  Future<void> searchEvents(String keyword) async {
    _searchQuery = keyword;

    if (keyword.isEmpty) {
      _filteredEvents = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _filteredEvents = await _repository.searchEvents(keyword);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Search failed: ${e.toString()}';
      _filteredEvents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredEvents = [];
    notifyListeners();
  }

  void navigateToDetail(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
    );
  }

  Future<void> refreshEvents() async {
    clearSearch();
    await fetchEvents();
  }

  bool hasError() => _errorMessage != null && _errorMessage!.isNotEmpty;
}
