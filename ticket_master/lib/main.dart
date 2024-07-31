import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const TicketMaster());
}

class TicketMaster extends StatefulWidget {
  const TicketMaster({super.key});

  @override
  TicketMasterState createState() => TicketMasterState();
}

class TicketMasterState extends State<TicketMaster> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue[600],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return IconButton(
                icon: Icon(
                  Icons.circle,
                  color: _currentPage == index ? Colors.white : Colors.grey,
                  size: 10,
                ),
                onPressed: () {
                  _pageController.jumpToPage(index);
                },
              );
            }),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: const Text(
            'Standard Tickets',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: true,
          toolbarHeight: 45,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: const [
            TicketPage(seatNumber: '1'),
            TicketPage(seatNumber: '2'),
            TicketPage(seatNumber: '3'),
            TicketPage(seatNumber: '4'),
          ],
        ),
      ),
    );
  }
}

class TicketPage extends StatefulWidget {
  final String seatNumber;

  const TicketPage({required this.seatNumber, super.key});

  @override
  TicketPageState createState() => TicketPageState();
}

class TicketPageState extends State<TicketPage> {
  late String section;
  late String row;
  late String date;
  late String time;
  late String imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
   
    section = 'FLR1';
    row = '7';
    date = '2024-08-01';
    time = '18:00';
    imageUrl = 'assets/images/seat1.png'; 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.blue[600]),
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SEC",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(section,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ROW",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(row,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SEAT",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(widget.seatNumber,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                imageUrl.startsWith('assets/')
                    ? Image.asset(imageUrl, height: 200, fit: BoxFit.cover)
                    : Image.file(File(imageUrl), height: 200, fit: BoxFit.cover),
                Text('Date: $date'),
                Text('Time: $time'),
                ElevatedButton(
                  onPressed: () {
                    _showEditDialog();
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Seat ${widget.seatNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Section'),
                onChanged: (value) {
                  setState(() {
                    section = value;
                  });
                },
                controller: TextEditingController(text: section),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Row'),
                onChanged: (value) {
                  setState(() {
                    row = value;
                  });
                },
                controller: TextEditingController(text: row),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Date'),
                onChanged: (value) {
                  setState(() {
                    date = value;
                  });
                },
                controller: TextEditingController(text: date),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Time'),
                onChanged: (value) {
                  setState(() {
                    time = value;
                  });
                },
                controller: TextEditingController(text: time),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      imageUrl = pickedFile.path;
                    });
                  }
                },
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }}