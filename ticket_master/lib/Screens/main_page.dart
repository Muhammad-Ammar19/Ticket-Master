import 'package:flutter/material.dart';

class TicketMaster extends StatelessWidget {
  const TicketMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: BottomAppBar(color: Colors.blue[600],height: 40,),
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
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(color: Colors.blue[600]),
              height: MediaQuery.of(context).size.height * 0.1,
              width: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SEC",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Text('FLR1',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ROW",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Text('7',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SEAT",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Text('4',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
