// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String> prayerTimes = {};
  bool loading = true;
  String city = "Rwanda"; // القيمة الافتراضية لو API ما موجود

  @override
  void initState() {
    super.initState();
    _getLocationAndPrayerTimes();
  }

  Future<void> _getLocationAndPrayerTimes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // لو عندك API لمواقيت الصلاة
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}?latitude=${position.latitude}&longitude=${position.longitude}&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Map timings = data['data']['timings'];

        setState(() {
          prayerTimes =
              timings.map((key, value) => MapEntry(key, value.toString()));
          loading = false;
          city = data['data']['meta']['timezone'] ?? city;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error fetching prayer times: $e');
    }
  }

  Widget _buildPrayerCard(String name, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(Icons.access_time, color: Colors.green.shade700),
        title: Text(name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(time, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.shade100,
                  child: Text(
                    'المدينة: $city',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: prayerTimes.entries
                        .map(
                            (entry) => _buildPrayerCard(entry.key, entry.value))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
