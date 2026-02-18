import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {
  final dynamic data;

  const Details({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final details = widget.data['data']['instant']['details'];
    final temperature = details['air_temperature'];
    final humidity = details['relative_humidity'];
    final pressure = details['air_pressure_at_sea_level'];
    final wind = details['wind_speed'];
    final windFromDirection = details['wind_from_direction'];
    final cloudAreaFraction = details['cloud_area_fraction'];
    String next = '';
    if (widget.data['data']['next_1_hours'] != null) {
      next =
          widget.data['data']['next_1_hours']['summary']['symbol_code'] ?? '';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat(
            'dd.MM.yyyy HH:mm:ss',
          ).format(DateTime.parse(widget.data['time']).toLocal()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              next != '' ? Image.asset('assets/$next.png') : SizedBox.shrink(),
              SizedBox(height: 16.0),
              Text(
                'Temperature: $temperature °C\n'
                'Humidity: $humidity %\n'
                'Pressure: $pressure hPa\n',
              ),
              SizedBox(height: 16.0),
              Text(
                'Wind speed: $wind m/s\n'
                'Wind from direction: $windFromDirection°',
              ),
              SizedBox(height: 16.0),
              Text('Cloud area fraction: $cloudAreaFraction %'),
            ],
          ),
        ),
      ),
    );
  }
}
