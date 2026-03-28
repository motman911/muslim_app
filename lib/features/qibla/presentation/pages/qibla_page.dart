import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/localization/app_localizations.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  late Future<bool> _permissionAndServiceFuture;
  late Future<bool?> _sensorSupportFuture;

  @override
  void initState() {
    super.initState();
    _permissionAndServiceFuture = _ensureLocationReady();
    _sensorSupportFuture = FlutterQiblah.androidDeviceSensorSupport();
  }

  Future<bool> _ensureLocationReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('qibla'))),
      body: FutureBuilder<bool>(
        future: _permissionAndServiceFuture,
        builder: (context, permissionSnapshot) {
          if (permissionSnapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (permissionSnapshot.data != true) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off_rounded, size: 88),
                    const SizedBox(height: 16),
                    Text(
                      l10n.tr('qiblaHint'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () async {
                        await Geolocator.openLocationSettings();
                        setState(() {
                          _permissionAndServiceFuture = _ensureLocationReady();
                        });
                      },
                      child: Text(l10n.tr('openLocationSettings')),
                    ),
                  ],
                ),
              ),
            );
          }

          return FutureBuilder<bool?>(
            future: _sensorSupportFuture,
            builder: (context, sensorSnapshot) {
              if (sensorSnapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (sensorSnapshot.data == false) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.tr('qiblaSensorNotSupported'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      l10n.tr('qiblaHint'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: StreamBuilder<dynamic>(
                        stream: FlutterQiblah.qiblahStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final data = snapshot.data;
                          final direction =
                              (data?.direction as num?)?.toDouble() ?? 0;
                          final qibla = (data?.qiblah as num?)?.toDouble() ?? 0;

                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: -direction * (math.pi / 180),
                                      child: const Icon(
                                        Icons.navigation_rounded,
                                        size: 190,
                                      ),
                                    ),
                                    Transform.rotate(
                                      angle: -qibla * (math.pi / 180),
                                      child: const Icon(
                                        Icons.near_me_rounded,
                                        size: 72,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${l10n.tr('qiblaAngle')}: ${qibla.toStringAsFixed(1)}°',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
