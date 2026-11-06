import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  GoogleMapController? mapController;
  Set<Marker> markers = {};

  double lat = 22.7196; // Indore fallback
  double lng = 75.8577;
  String formattedAddress = '';

  // Google Places
  final String _googleApiKey = 'AIzaSyAw5iIsWyZnq8Ejy8jLC2jcKvNRxI5Ll3w'; // ← apna key
  final String _sessionToken = const Uuid().v4();
  List<dynamic> _predictions = [];
  bool _showSuggestions = false;
  Timer? _debounce;

  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ==================== CURRENT LOCATION ====================
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _updateMarker(lat, lng);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _updateMarker(lat, lng);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _updateMarker(lat, lng);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude;
      lng = position.longitude;
      _updateMarker(lat, lng);
      await _reverseGeocode(lat, lng);
    } catch (e) {
      debugPrint('Location error: $e');
      _updateMarker(lat, lng);
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _updateMarker(double latitude, double longitude) {
    setState(() {
      lat = latitude;
      lng = longitude;
      markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: LatLng(latitude, longitude),
          draggable: true,
          onDragEnd: (newPos) {
            _onMapTapped(newPos);
          },
        ),
      };
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 16),
    );
  }

  // ==================== SEARCH ====================
  void _onSearchChanged(String input) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (input.trim().length > 2) {
        _getPlacePredictions(input);
      } else {
        setState(() {
          _predictions = [];
          _showSuggestions = false;
        });
      }
    });
  }

  Future<void> _getPlacePredictions(String input) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(input)}'
          '&key=$_googleApiKey'
          '&sessiontoken=$_sessionToken'
          '&components=country:in',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            _predictions = data['predictions'] ?? [];
            _showSuggestions = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Places error: $e');
    }
  }

  Future<void> _selectPrediction(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final description = prediction['description'] ?? '';

    setState(() {
      _searchCtrl.text = description;
      _showSuggestions = false;
      _predictions = [];
    });

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&key=$_googleApiKey'
          '&sessiontoken=$_sessionToken'
          '&fields=geometry,formatted_address',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];
          final location = result['geometry']['location'];
          final newLat = (location['lat'] as num).toDouble();
          final newLng = (location['lng'] as num).toDouble();
          final formatted = result['formatted_address'] ?? description;

          setState(() {
            formattedAddress = formatted;
          });
          _updateMarker(newLat, newLng);
        }
      }
    } catch (e) {
      debugPrint('Place details error: $e');
    }
  }

  // ==================== REVERSE GEOCODE ====================
  Future<void> _reverseGeocode(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''} - ${place.postalCode ?? ''}';

        setState(() {
          formattedAddress = address.trim().replaceAll(RegExp(r'^,\s*|,\s*$'), '');
          _searchCtrl.text = formattedAddress;
        });
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }
  }

  void _onMapTapped(LatLng position) {
    _updateMarker(position.latitude, position.longitude);
    _reverseGeocode(position.latitude, position.longitude);
  }

  // ==================== CONFIRM ====================
  void _confirmLocation() {
    if (formattedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    Navigator.pop(context, {
      'lat': lat,
      'lng': lng,
      'address': formattedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Garage Address'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // ==================== MAP ====================
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 16,
                  ),
                  onMapCreated: (c) => mapController = c,
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onTap: _onMapTapped,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                ),

                // Search Bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(30),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search area, street, landmark...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchCtrl.text.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {
                                  _predictions = [];
                                  _showSuggestions = false;
                                });
                              },
                            )
                                : null,
                          ),
                        ),
                      ),

                      // Suggestions
                      if (_showSuggestions && _predictions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          constraints: const BoxConstraints(maxHeight: 220),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _predictions.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final p = _predictions[index];
                              return ListTile(
                                dense: true,
                                leading: const Icon(Icons.location_on_outlined, size: 20),
                                title: Text(
                                  p['description'] ?? '',
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () => _selectPrediction(p),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // Use My Location Button
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    child: InkWell(
                      onTap: _isLoadingLocation ? null : _getCurrentLocation,
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isLoadingLocation)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              const Icon(Icons.my_location, size: 18, color: Colors.red),
                            const SizedBox(width: 6),
                            Text(
                              _isLoadingLocation ? 'Getting...' : 'Use My Location',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================== BOTTOM CARD ====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'SELECTED LOCATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  formattedAddress.isNotEmpty
                      ? formattedAddress
                      : 'Move pin or search location',
                  style: TextStyle(
                    fontSize: 15,
                    color: formattedAddress.isNotEmpty
                        ? Colors.black87
                        : Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8), // apna primary color daal sakte ho
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirm Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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