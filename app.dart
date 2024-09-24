import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Previsão do Tempo',
      theme: ThemeData(
        primaryColor: Color(0xFFED7B83),
        focusColor: Color(0xFFEC8A90),
        scaffoldBackgroundColor: Color(0xFFEEE9C7),
        textTheme: TextTheme(
          titleMedium: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          titleLarge: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFFED7B83),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFE6D1CA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFEC8A90),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final List<Map<String, String>> _cities = [];
  final TextEditingController _controller = TextEditingController();

  void _addCity(String cityName) {
    final random = Random();
    final temperature = (random.nextInt(35) + 5).toString(); // Temperatura aleatória entre 5 e 40
    setState(() {
      _cities.add({'name': cityName, 'temperature': temperature});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addCity(_controller.text);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20), // Aumenta a distância entre a barra de entrada e a lista
            Expanded(
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEC8A90)),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xFFE6D1CA),
                    ),
                    child: ListTile(
                      title: Text(
                        _cities[index]['name']!,
                        style: TextStyle(fontSize: 18), // Aumenta a fonte dos itens
                      ),
                      subtitle: Text(
                        'Temperatura: ${_cities[index]['temperature']}°C',
                        style: TextStyle(fontSize: 16), // Aumenta a fonte dos itens
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityWeatherPage(
                              cityName: _cities[index]['name']!,
                              currentTemperature: _cities[index]['temperature']!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityWeatherPage extends StatelessWidget {
  final String cityName;
  final String currentTemperature;

  CityWeatherPage({required this.cityName, required this.currentTemperature});

   @override
  Widget build(BuildContext context) {
    final random = Random();
    final List<String> daysOfWeek = ['Segunda feira', 'Terça feira', 'Quarta feira', 'Quita Feira', 'Sexta feira', 'Sábado', 'Domingo'];
    final List<Map<String, String>> nextTemperatures = List.generate(5, (index) {
      final day = daysOfWeek[(DateTime.now().weekday + index) % 7];
      final temperature = (random.nextInt(35) + 5).toString();
      return {'dia': day, 'temperatura': temperature};
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperatura',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              '$currentTemperature°C',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Text(
              'Previsão para 5 dias',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: nextTemperatures.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(nextTemperatures[index]['dia']!),
                    trailing: Text('${nextTemperatures[index]['temperatura']}°C'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
