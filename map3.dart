import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// =======================================================
/// กรณีเกิดปัญหา CERTIFICATE_VERIFY_FAILED (ใช้เฉพาะตอนทดสอบ)
/// =======================================================
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Map3 extends StatefulWidget {
  const Map3({Key? key}) : super(key: key);

  @override
  State<Map3> createState() => _Map3State();
}

class _Map3State extends State<Map3> {
  GoogleMapController? _mapController;

  /// ตำแหน่งเริ่มต้น (ตั้งค่าเริ่มต้นก่อนโหลด API)
  LatLng _center = const LatLng(17.39762, 102.7943);

  /// เก็บ Marker ทั้งหมด
  Set<Marker> _markers = {};

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    /// เปิดใช้เฉพาะตอนเจอปัญหา SSL
    HttpOverrides.global = MyHttpOverrides();

    _fetchLocations();
  }

  /// =======================================================
  /// ดึงข้อมูลพิกัดจาก PHP API
  /// =======================================================
  Future<void> _fetchLocations() async {
    final url = Uri.parse(
      'http://10.0.2.2/get_location.php',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        Set<Marker> tempMarkers = {};

        for (var item in data) {
          LatLng position = LatLng(
            double.parse(item['latitude'].toString()),
            double.parse(item['longitude'].toString()),
          );

          tempMarkers.add(
            Marker(
              markerId: MarkerId(item['id'].toString()),
              position: position,
              infoWindow: InfoWindow(
                title: item['name'],
              ),
            ),
          );
        }

        setState(() {
          _markers = tempMarkers;

          /// เลื่อนกล้องไปตำแหน่งแรก
          if (data.isNotEmpty) {
            _center = LatLng(
              double.parse(data[0]['latitude'].toString()),
              double.parse(data[0]['longitude'].toString()),
            );
          }

          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// =======================================================
  /// สร้าง Google Map
  /// =======================================================
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map from MySQL (Workshop 9.3)'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14,
        ),
        markers: _markers,
      ),
    );
  }
}
