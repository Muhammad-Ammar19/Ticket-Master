import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'Helpers/ticket_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TicketAdapter());
  await Hive.openBox<Ticket>('tickets');

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
  List<String> _seatNumbers = [];

  @override
  void initState() {
    super.initState();
    _loadSeatNumbers();
  }

  void _loadSeatNumbers() {
    final box = Hive.box<Ticket>('tickets');
    setState(() {
      _seatNumbers = box.values.map((ticket) => ticket.seatNumber).toList();
      if (_seatNumbers.isEmpty) {
        _seatNumbers = List.generate(4, (index) => (index + 1).toString());
        _saveDefaultTickets();
      }
    });
  }

  void _saveDefaultTickets() {
    final box = Hive.box<Ticket>('tickets');
    for (var seatNumber in _seatNumbers) {
      box.put(
          seatNumber,
          Ticket(
            seatNumber: seatNumber,
            section: 'FLR1',
            row: '0',
            date: '2024-08-01',
            time: '00:00',
            imageUrl: 'assets/images/seat1.png',
          ));
    }
  }

  void _addNewPage() {
    final newSeatNumber = (_seatNumbers.length + 1).toString();
    setState(() {
      _seatNumbers.add(newSeatNumber);
      _pageController.jumpToPage(_seatNumbers.length - 1);

      final box = Hive.box<Ticket>('tickets');
      box.put(
          newSeatNumber,
          Ticket(
            seatNumber: newSeatNumber,
            section: 'FLR1',
            row: '0',
            date: '2024-08-01',
            time: '00:00',
            imageUrl: 'assets/images/seat1.png',
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomAppBar(
          height: 60,
          color: Colors.blue[600],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_seatNumbers.length, (index) {
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
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: const Text(
            'Standard Tickets',
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w500, color: Colors.white),
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
          children: _seatNumbers
              .map((seatNumber) => TicketPage(seatNumber: seatNumber))
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewPage,
          child: const Icon(Icons.add),
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
  final Box<Ticket> _ticketBox = Hive.box<Ticket>('tickets');

  @override
  void initState() {
    super.initState();
    _loadTicketDetails();
  }

  void _loadTicketDetails() {
    final ticket = _ticketBox.get(widget.seatNumber,
        defaultValue: Ticket(
          seatNumber: widget.seatNumber,
          section: 'FLR1',
          row: '0',
          date: '2024-08-01',
          time: '00:00',
          imageUrl: 'assets/images/seat1.png',
        ));

    setState(() {
      section = ticket!.section;
      row = ticket.row;
      date = ticket.date;
      time = ticket.time;
      imageUrl = ticket.imageUrl;
    });
  }

  void _saveTicketDetails() {
    final ticket = Ticket(
      seatNumber: widget.seatNumber,
      section: section,
      row: row,
      date: date,
      time: time,
      imageUrl: imageUrl,
    );
    _ticketBox.put(widget.seatNumber, ticket);
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      "assets/images/artist.jpeg",
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              const Text(
                                "SZA - SOS TOUR",
                                style: TextStyle(
                                  letterSpacing: 3,
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Date • $date',
                                    style: const TextStyle(letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 17),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Time • $time',
                                    style: const TextStyle(letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InstaImageViewer(
                  child: imageUrl.startsWith('assets/')
                      ? Image.asset(imageUrl, height: 100, fit: BoxFit.cover)
                      : Image.file(File(imageUrl),
                          height: 100, fit: BoxFit.cover),
                ),
                // const SizedBox(height: 10),
                // Text(
                //   'Date: $date',
                //   style: const TextStyle(
                //       fontWeight: FontWeight.w500, fontSize: 17),
                // ),
                // const SizedBox(height: 10),
                // Text(
                //   'Time: $time',
                //   style: const TextStyle(
                //       fontWeight: FontWeight.w500, fontSize: 17),
                // ),
              
                const SizedBox(height: 60),
                const Text(
                  "FLOOR SEATING",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    onPressed: () {
                      _showEditDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      backgroundColor: Colors.black,
                      shadowColor: Colors.black,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'View Barcode',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800]),
                    ),
                    Text(
                      'Ticket Details',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800]),
                    ),
                  ],
                )
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
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
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
                _saveTicketDetails();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
