import 'dart:convert';

import 'package:example/favorites/favorites.dart';
import 'package:example/forecast/details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Forecast extends StatefulWidget {
  const Forecast({super.key});

  @override
  State<StatefulWidget> createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  bool _loading = false;
  Position? _location;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getLocation().then((position) {
      debugPrint('Location: $position');
      setState(() {
        _location = position;
        _loading = false;
      });
    });
  }

  Future<Position> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location is not available');
    }
    return await GeolocatorPlatform.instance.getCurrentPosition();
  }

  Future<List<dynamic>> getTimeseries(String latitude, String longitude) async {
    final response = await http.get(
      Uri.https('api.met.no', 'weatherapi/locationforecast/2.0/compact', {
        'lat': latitude,
        'lon': longitude,
      }),
      headers: {'User-Agent': 'MyApp/1.0 (ylari.ainjarv@gmail.com)'},
    );
    if (response.statusCode != 200) {
      throw Exception('HTTP error ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    debugPrint('Data: $data');
    return data['properties']['timeseries'];
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Weather Forecast'),
              actions: [
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Favorites()),
                    );
                  },
                ),
              ],
            ),
            body: FutureBuilder(
              future: getTimeseries(
                _location!.latitude.toString(),
                _location!.longitude.toString(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final items = snapshot.data as List<dynamic>;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final time = DateFormat(
                      'dd.MM.yyyy HH:mm:ss',
                    ).format(DateTime.parse(item['time']).toLocal());
                    final details = item['data']['instant']['details'];
                    final temperature = details['air_temperature'];
                    final humidity = details['relative_humidity'];
                    final pressure = details['air_pressure_at_sea_level'];
                    final wind = details['wind_speed'];
                    String next = '';
                    if (item['data']['next_1_hours'] != null) {
                      next =
                          item['data']['next_1_hours']['summary']['symbol_code'] ??
                          '';
                    }
                    return ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(
                        time,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Temperature: $temperature °C\n'
                        'Humidity: $humidity %\n'
                        'Pressure: $pressure hPa\n'
                        'Wind speed: $wind m/s',
                      ),
                      trailing: next != ''
                          ? Image.asset('assets/$next.png')
                          : null,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(data: item),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
  }
}
