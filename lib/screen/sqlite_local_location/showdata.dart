import 'package:flutter/material.dart';
import 'local_db_service.dart';
import 'model.dart';

class LocationLogsPage extends StatefulWidget {
  const LocationLogsPage({super.key});

  @override
  State<LocationLogsPage> createState() => _LocationLogsPageState();
}

class _LocationLogsPageState extends State<LocationLogsPage> {
  List<LocationLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LocalDbService.instance.getAllLocations();

    setState(() {
      _logs = data;
      _isLoading = false;
    });
  }

  Future<void> _clearAll() async {
    await LocalDbService.instance.clearLocations();

    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All locations cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stored Locations'),
        actions: [
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _logs.isEmpty
              ? const Center(child: Text('No location records found'))
              : ListView.separated(
                itemCount: _logs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _logs[index];

                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking: ${item.bookingId}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),

                          Text('Latitude : ${item.latitude}'),
                          Text('Longitude: ${item.longitude}'),

                          const SizedBox(height: 8),

                          Text(
                            'Distance From Prev: '
                            '${item.distanceFromPrev.toStringAsFixed(2)} m',
                          ),

                          Text(
                            'Total Distance: '
                            '${item.cumulativeDistance.toStringAsFixed(2)} m',
                          ),

                          Text(
                            'Total Distance: '
                            '${(item.cumulativeDistance / 1000).toStringAsFixed(2)} km',
                          ),

                          const SizedBox(height: 8),

                          Text('Time: ${item.dateTime}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
