// lib/presentation/screens/quran_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: unused_import
import '../../core/constants/color_scheme.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final List<Map<String, dynamic>> _allSurahs = [
    {'number': 1, 'name': 'الفاتحة', 'ayahs': 7, 'type': 'مكية', 'page': 1},
    {'number': 2, 'name': 'البقرة', 'ayahs': 286, 'type': 'مدنية', 'page': 2},
    {
      'number': 3,
      'name': 'آل عمران',
      'ayahs': 200,
      'type': 'مدنية',
      'page': 50
    },
    {'number': 4, 'name': 'النساء', 'ayahs': 176, 'type': 'مدنية', 'page': 77},
    {
      'number': 5,
      'name': 'المائدة',
      'ayahs': 120,
      'type': 'مدنية',
      'page': 106
    },
    {'number': 6, 'name': 'الأنعام', 'ayahs': 165, 'type': 'مكية', 'page': 128},
    {'number': 7, 'name': 'الأعراف', 'ayahs': 206, 'type': 'مكية', 'page': 151},
    {'number': 8, 'name': 'الأنفال', 'ayahs': 75, 'type': 'مدنية', 'page': 177},
    {'number': 9, 'name': 'التوبة', 'ayahs': 129, 'type': 'مدنية', 'page': 187},
    {'number': 10, 'name': 'يونس', 'ayahs': 109, 'type': 'مكية', 'page': 208},
    // TODO: أكمل باقي السور حتى 114
  ];

  List<Map<String, dynamic>> _filteredSurahs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredSurahs = _allSurahs;
    _searchController.addListener(_filterSurahs);
  }

  void _filterSurahs() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          return surah['name'].contains(query) ||
              surah['number'].toString().contains(query) ||
              surah['type'].contains(query);
        }).toList();
      }
    });
  }

  Color _getSurahColor(Map<String, dynamic> surah) {
    return surah['type'] == 'مكية' ? Colors.deepPurple : Colors.teal;
  }

  IconData _getSurahIcon(Map<String, dynamic> surah) {
    return surah['type'] == 'مكية'
        ? FontAwesomeIcons.moon
        : FontAwesomeIcons.mosque;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('القرآن الكريم', style: TextStyle(fontFamily: 'Lateef')),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة بالاسم أو الرقم',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
          ),
          Expanded(
            child: _filteredSurahs.isEmpty
                ? const Center(child: Text('لم يتم العثور على سورة'))
                : ListView.builder(
                    itemCount: _filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surah = _filteredSurahs[index];
                      final color = _getSurahColor(surah);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.2),
                            child: Text(
                              '${surah['number']}',
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(surah['name'],
                              style: theme.textTheme.bodyLarge),
                          subtitle:
                              Text('${surah['type']} - ${surah['ayahs']} آية'),
                          trailing: Icon(_getSurahIcon(surah), color: color),
                          onTap: () {
                            // TODO: فتح صفحة قراءة السورة أو التلاوة
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
