import 'package:flutter/material.dart';
import 'package:game_fun_bonfire/conts/consts.dart';
import 'package:game_fun_bonfire/themes/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

import '../themes/theme.dart';
import '../themes/theme_provider.dart';

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final WeatherFactory _wf = WeatherFactory(apiKey);
  final TextEditingController textControllerCityName = TextEditingController();

  Weather? _weather;

  late String? cityName = 'Xangai';

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(cityName!).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  void changeCity() async {
    setState(() {
      cityName = textControllerCityName.text;
    });

    Weather? newWeather = await _wf.currentWeatherByCityName(cityName!);

    setState(() {
      _weather = newWeather;
    });
  }

  Future<void> showCardNewCity() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.sizeOf(context).height * 0.50,
            width: MediaQuery.sizeOf(context).width * 0.30,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      label: Text('City name'),
                      icon: Icon(Icons.wordpress),
                    ),
                    keyboardType: TextInputType.text,
                    controller: textControllerCityName,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        changeCity();
                        Navigator.pop(context);
                        textControllerCityName.text = '';
                      });
                    },
                    child: const Icon(
                      Icons.check,
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _buildUi(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCardNewCity(),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildUi() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _switchMode(),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            _locationHeader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _extraInfo(),
          ],
        ),
      ),
    );
  }

  Widget _switchMode() {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              child: Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: Theme.of(context).colorScheme.primary),
                  Icon(Icons.nightlight_round, color: Theme.of(context).colorScheme.tertiary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? '',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat.Hm().format(now),
          style: const TextStyle(fontSize: 32),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat.yMMMMd('en_US').format(now),
              style: const TextStyle(
                // fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Text(
            //   DateFormat('d.m.y').format(now),
            //   style: const TextStyle(
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.18,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png',
              ),
            ),
          ),
        ),
        Text(_weather?.weatherDescription ?? ''),
      ],
    );
  }

  Widget _currentTemp() {
    return Column(
      children: [
        Text(
          '${_weather?.temperature?.celsius?.toStringAsFixed(0)}º C',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 70,
          ),
        ),
        Text(
          'Thermal sensation: ${_weather?.tempFeelsLike?.celsius?.toStringAsFixed(0)}º C',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.20,
      width: MediaQuery.sizeOf(context).width * 0.70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}º C',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                'Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}º C',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                'Humity: ${_weather?.humidity?.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sunrise: ${_weather?.sunrise?.hour.toString().padLeft(2, '0')}:${_weather?.sunrise?.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                'Sunset: ${_weather?.sunset?.hour.toString().padLeft(2, '0')}:${_weather?.sunset?.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
