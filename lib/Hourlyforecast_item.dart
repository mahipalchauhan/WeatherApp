import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyForecast(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(
              ' $temperature K',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
