import 'package:flutter/material.dart';
import 'package:kosher_calendar/kosher_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),      
    );
  }
}

class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(40),
            child: KosherCalendar(selectedDate: DateTime.now(), isKosher: true, accentColor: Color(0xFF3E629C),),
          )),
        ],
      ));
  }
}