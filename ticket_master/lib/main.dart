import 'package:flutter/material.dart';
import 'package:ticket_master/Screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Master',
      theme: ThemeData(),
      home: const TicketMaster(),
    );
  }
}
