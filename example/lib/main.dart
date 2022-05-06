import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_dropper/time_dropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Dropper Example',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          accentColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();
  TimeOfDay? _time1;
  TimeOfDay? _time2;
  TimeOfDay? _time3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Time Dropper Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FractionallySizedBox(
              widthFactor: 0.5,
              child: OutlinedButton(
                key: _key1,
                child: Text(_time1 == null ? "Select time 1" : _time1!.format(context)),
                onPressed: () => _showPicker(_key1),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: OutlinedButton(
                  key: _key2,
                  child: Text(_time2 == null ? "Select time 2" : _time2!.format(context)),
                  onPressed: () => _showPicker(_key2),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: OutlinedButton(
                  key: _key3,
                  child: Text(_time3 == null ? "Select time 3" : _time3!.format(context)),
                  onPressed: () => _showPicker(_key3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showPicker(GlobalKey key) {
    showTimeDropper(
      context: context,
      onDone: print,
      onTimeChanged: (time) {
        setState(() {
          if (key == _key1) _time1 = time;
          if (key == _key2) _time2 = time;
          if (key == _key3) _time3 = time;
        });
      },
      containerKey: key,
      initialTime: key == _key1
          ? _time1
          : key == _key2
              ? _time2
              : _time3,
      style: key == _key1
          ? TimeDropperStyle.outerFilled
          : key == _key2
              ? TimeDropperStyle.innerFilled
              : TimeDropperStyle.bordered,
      barrierColor: Colors.black26,
      themeData: TimeDropperThemeData(elevation: 2),
    );
  }
}
