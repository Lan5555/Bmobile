// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleRide extends StatefulWidget {
  const ScheduleRide({super.key});
  @override
  RideSchedule createState() => RideSchedule();
}

class RideSchedule extends State<ScheduleRide> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get _firstDayOfTheMonth => DateTime(_focusedDay.month, 1);
  DateTime get _lastDayOfTheMonth =>
      DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

  List<Widget> containers = [
    _showPendingRide(
        loaction: "Bukuru", status: "pending", time: DateTime.now()),
    _showPendingRide(
        loaction: "Bukuru", status: "pending", time: DateTime.now()),
    _showPendingRide(
        loaction: "Bukuru", status: "pending", time: DateTime.now()),
    _showPendingRide(
        loaction: "Bukuru", status: "pending", time: DateTime.now()),
    _showPendingRide(
        loaction: "Bukuru", status: "pending", time: DateTime.now()),
    _showPendingRide(
        loaction: "Bukuru", status: "pending", time: DateTime.now()),
  ];

  List<Widget> History = [
    _showHistory(loaction: "Bukuru", status: "Delivered", time: DateTime.now())
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TabBar at the top
            TabBar(
              tabs: [
                Tab(text: "Schedule"),
                Tab(text: "Pending Rides"),
                Tab(text: "History"),
              ],
            ),
            //SizedBox(height: 20,),
            // TabBarView for showing content based on selected tab
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TableCalendar(
                        focusedDay: _focusedDay,
                        firstDay: _firstDayOfTheMonth,
                        lastDay: _lastDayOfTheMonth,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerVisible: true,
                        calendarFormat: CalendarFormat.month,
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                        ),
                        onPressed: () {},
                        label: Text(
                          "Schedule ride",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.drive_eta,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
                  Center(
                      child: SingleChildScrollView(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: containers,
                  ))),
                  Center(child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: History,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _showPendingRide({String? loaction, DateTime? time, String? status}) {
  Color color = Colors.yellow;
  if (status! == "accepted") {
    color = Colors.green;
  } else {
    color = Colors.yellow;
  }
  return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1.75 * 16,
                    spreadRadius: 0.0,
                    color: Color.fromRGBO(33, 40, 50, 0.15),
                    offset: Offset(0, 0.15 * 16))
              ]),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: ListTile(
              leading: Icon(
                Icons.drive_eta_rounded,
                color: Colors.blue,
              ),
              title: Text(
                loaction!,
                style: TextStyle(fontSize: 15),
              ),
              trailing: Text(
                status,
                style: TextStyle(color: color),
              ),
              subtitle: Text(
                '$time',
                style: TextStyle(fontSize: 10),
              ),
            ),
          )));
}

Widget _showHistory({String? loaction, DateTime? time, String? status}) {
  Color color = Colors.red;
  if (status! == "Delivered") {
    color = Colors.green;
  } else {
    color = Colors.red;
  }
  return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1.75 * 16,
                    spreadRadius: 0.0,
                    color: Color.fromRGBO(33, 40, 50, 0.15),
                    offset: Offset(0, 0.15 * 16))
              ]),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: ListTile(
              leading: Icon(
                Icons.drive_eta_rounded,
                color: Colors.blue,
              ),
              title: Text(
                status,
                style: TextStyle(fontSize: 20, color: color,fontWeight: FontWeight.bold,fontFamily: "GowunBatang"),
              ),
              trailing: Text(
                loaction!,
              ),
              subtitle: Text(
                '$time',
                style: TextStyle(fontSize: 10),
              ),
            ),
          )));
}
