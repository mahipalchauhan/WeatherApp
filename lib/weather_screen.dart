import 'dart:convert';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Hourlyforecast_item.dart';
import 'package:weather_app/additionalinfoitem.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    print("fn called");
    try {
      String cityName = 'Mumbai';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'an unexpected occur';
      }

      return data;
      //  temp = (data['list'][0]['main']['temp']);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    print("build cLLLED");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Weather app",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          // backgroundColor: const Color.fromARGB(255, 12, 12, 12),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            print(snapshot);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            final data = snapshot.data!;
            final currentweather = data['list'][0];
            final currentTemp = currentweather['main']['temp'];
            final currentSky = currentweather['weather'][0]['main'];
            final currentPressure = currentweather['main']['pressure'];
            final currentSpeed = currentweather['wind']['speed'];
            final currentHumitidy = currentweather['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${(currentTemp - 273).toStringAsFixed(2)}°C',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                    currentSky == 'Clouds' ||
                                            currentSky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 64),
                                const SizedBox(height: 16),
                                Text(currentSky,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 22)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //weather forecast tab
                  const SizedBox(height: 15),

                  const Text("Weather Forecast",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 8; i++)
                  //         HourlyForecast(
                  //             time: data['list'][i + 1]['dt'].toString(),
                  //             icon: data['list'][i + 5]['weather'][0]['main'] ==
                  //                         'Clouds' ||
                  //                     data['list'][i + 1]['weather'][0]
                  //                             ['main'] ==
                  //                         'Rain'
                  //                 ? Icons.cloud
                  //                 : Icons.sunny,
                  //             temperature: data['list'][i + 1]['main']['temp']
                  //                 .toString()),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);

                        return HourlyForecast(
                          time: DateFormat.j().format(time),
                          temperature: data['list'][index + 1]['main']['temp']
                              .toString(),
                          icon: data['list'][index + 5]['weather'][0]['main'] ==
                                      'Clouds' ||
                                  data['list'][index + 1]['weather'][0]
                                          ['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Additional Info",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: "humidity",
                          value: currentHumitidy.toString()),
                      AdditionalInfoItem(
                          icon: Icons.air,
                          label: "Wind speed",
                          value: currentSpeed.toString()),
                      AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: "pressure",
                          value: currentPressure.toString()),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
