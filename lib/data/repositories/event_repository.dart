import '../models/event_model.dart';

class EventRepository {
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<List<Event>> fetchEvents() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockResponse = [
        {
          'id': '1',
          'title': 'Tech Talk',
          'date': '2025-11-15',
          'imageUrl': 'https://picsum.photos/400/300?random=1',
          'description': 'Tech Talk adalah acara berbagi wawasan seputar tren dan inovasi teknologi yang dibawakan oleh ahli dan praktisi industri.',
          'organizer': 'PT. Tech Indonesia, PT. Jaya Indonesia',
          'location': 'Gedung DPR, Ruang Rapat Lt.5',
        },
        {
          'id': '2',
          'title': 'Halloween Costume Party',
          'date': '2025-11-28',
          'imageUrl': 'https://picsum.photos/400/300?random=2',
          'description': 'Rayakan Halloween dengan kostum menarik dan berbagai hiburan seru.',
          'organizer': 'Event Organizer XYZ',
          'location': 'Convention Center, Hall A',
        },
        {
          'id': '3',
          'title': 'Web Development Workshop',
          'date': '2025-12-10',
          'imageUrl': 'https://picsum.photos/400/300?random=3',
          'description': 'Workshop intensif tentang pengembangan web modern dengan teknologi terkini.',
          'organizer': 'Code Academy Indonesia',
          'location': 'Tech Hub Central, Studio 1',
        },
        {
          'id': '4',
          'title': 'Annual Music Festival',
          'date': '2025-12-20',
          'imageUrl': 'https://picsum.photos/400/300?random=4',
          'description': 'Festival musik tahunan menampilkan berbagai artis lokal dan internasional.',
          'organizer': 'Music Events Co.',
          'location': 'Jakarta International Expo',
        },
        {
          'id': '5',
          'title': 'Business Networking Summit',
          'date': '2025-12-28',
          'imageUrl': 'https://picsum.photos/400/300?random=5',
          'description': 'Acara networking untuk profesional bisnis dan entrepreneur.',
          'organizer': 'Business Leaders Forum',
          'location': 'Menara Mandiri, Lantai 30',
        },
        {
          'id': '6',
          'title': 'Digital Marketing Masterclass',
          'date': '2026-01-15',
          'imageUrl': 'https://picsum.photos/400/300?random=6',
          'description': 'Kelas master tentang strategi digital marketing dan social media.',
          'organizer': 'Digital Marketing Institute',
          'location': 'Online & Hybrid Event',
        },
        {
          'id': '7',
          'title': 'AI & Machine Learning Conference',
          'date': '2026-02-10',
          'imageUrl': 'https://picsum.photos/400/300?random=7',
          'description': 'Konferensi tentang perkembangan AI dan Machine Learning di industri.',
          'organizer': 'Tech Innovation Hub',
          'location': 'Convention Center, Hall B',
        },
        {
          'id': '8',
          'title': 'Cloud Architecture Masterclass Advanced Training',
          'date': '2026-03-05',
          'imageUrl': 'https://picsum.photos/400/300?random=8',
          'description': 'Pembelajaran mendalam tentang arsitektur cloud dan best practices deployment.',
          'organizer': 'Cloud Computing Academy',
          'location': 'Tech Campus, Building A',
        },
        {
          'id': '9',
          'title': 'Startup Pitching Competition',
          'date': '2026-03-20',
          'imageUrl': 'https://picsum.photos/400/300?random=9',
          'description': 'Kompetisi pitch startup dengan hadiah total miliaran rupiah.',
          'organizer': 'Startup Indonesia Network',
          'location': 'Innovation Hub, Jakarta',
        },
        {
          'id': '10',
          'title': 'Mobile App Development Summit',
          'date': '2026-04-12',
          'imageUrl': 'https://picsum.photos/400/300?random=10',
          'description': 'Summit tentang pengembangan aplikasi mobile cross-platform.',
          'organizer': 'Mobile Dev Community',
          'location': 'Digital Innovation Center',
        },
        {
          'id': '11',
          'title': 'Cybersecurity & Data Protection Workshop',
          'date': '2026-04-25',
          'imageUrl': 'https://picsum.photos/400/300?random=11',
          'description': 'Workshop praktis tentang keamanan siber dan perlindungan data.',
          'organizer': 'Security Institute',
          'location': 'Convention Center, Hall C',
        },
        {
          'id': '12',
          'title': 'UX/UI Design Excellence Conference',
          'date': '2026-05-10',
          'imageUrl': 'https://picsum.photos/400/300?random=12',
          'description': 'Konferensi tentang desain user experience dan interface terbaik.',
          'organizer': 'Design Professionals Association',
          'location': 'Creative Hub, Jakarta',
        },
        {
          'id': '13',
          'title': 'DevOps & Infrastructure Automation',
          'date': '2026-05-28',
          'imageUrl': 'https://picsum.photos/400/300?random=13',
          'description': 'Workshop mengenai DevOps practices dan automation infrastructure.',
          'organizer': 'DevOps Indonesia',
          'location': 'Tech Hub Central, Studio 2',
        },
        {
          'id': '14',
          'title': 'Women in Technology Summit',
          'date': '2026-06-15',
          'imageUrl': 'https://picsum.photos/400/300?random=14',
          'description': 'Summit khusus membahas peran wanita dalam industri teknologi.',
          'organizer': 'Women Tech Leaders',
          'location': 'Jakarta International Expo',
        },
      ];
      return mockResponse.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  Future<Event> fetchEventById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockEvent = {
        'id': id,
        'title': 'Mock Event',
        'date': '2025-11-15',
        'imageUrl': 'https://picsum.photos/400/300?random=$id',
      };

      return Event.fromJson(mockEvent);
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }
  Future<List<Event>> searchEvents(String keyword) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final allEvents = await fetchEvents();
      return allEvents
          .where((event) => event.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Error searching events: $e');
    }
  }
}