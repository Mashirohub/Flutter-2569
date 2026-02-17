import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  LatLng _selectedPosition = const LatLng(13.7563, 100.5018);
  final TextEditingController _nameController = TextEditingController();

  Set<Marker> _markers = {};

  final String saveUrl = "http://10.0.2.2/save_location.php";
  final String getUrl  = "http://10.0.2.2/get_location.php";

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  // โหลดหมุดจากฐานข้อมูล
  Future<void> _loadLocations() async {
    try {
      var response = await http.get(Uri.parse(getUrl));
      var data = json.decode(response.body);

      Set<Marker> loadedMarkers = {};

      for (var item in data) {
        loadedMarkers.add(
          Marker(
            markerId: MarkerId(item['id'].toString()),
            position: LatLng(
              double.parse(item['latitude']),
              double.parse(item['longitude']),
            ),
            draggable: true,
            infoWindow: InfoWindow(title: item['name']),
            onDragEnd: (newPos) {
              print("Marker ${item['id']} moved");
            },
          ),
        );
      }

      setState(() {
        _markers = loadedMarkers;
      });

    } catch (e) {
      print("Load error: $e");
    }
  }

  // บันทึกหมุด
  Future<void> _saveLocation() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณาใส่ชื่อสถานที่")),
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(saveUrl),
        body: {
          "name": _nameController.text,
          "latitude": _selectedPosition.latitude.toString(),
          "longitude": _selectedPosition.longitude.toString(),
        },
      );

      var data = json.decode(response.body);

      if (data["status"] == "success") {
        _nameController.clear();
        _loadLocations();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("บันทึกสำเร็จ")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เกิดข้อผิดพลาด")),
        );
      }

    } catch (e) {
      print("Save error: $e");
    }
  }

  // แตะแผนที่เพื่อสร้างหมุด
  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;

      // ลบหมุดชั่วคราวเก่า
      _markers.removeWhere(
              (marker) => marker.markerId.value == "selected");

      _markers.add(
        Marker(
          markerId: const MarkerId("selected"),
          position: position,
          draggable: true,
          onDragEnd: (newPos) {
            setState(() {
              _selectedPosition = newPos;
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Save Location")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 14,
              ),
              markers: _markers,
              onTap: _onMapTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "ชื่อสถานที่ (ไทย / English)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveLocation,
                    child: const Text("Save Location"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
