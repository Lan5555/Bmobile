import 'package:b_mobile/main.dart';
import 'package:b_mobile/pages/body.dart';
import 'package:b_mobile/pages/home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<Settings> {
  bool isNotificationOn = false;
  bool isDeviceSelected = true;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.blue),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.blue,
              )),
          backgroundColor: Colors.white,
          elevation: 3,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                title: const Text(
                  'John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Edit your profile picture',
                  style: TextStyle(fontSize: 10.0),
                ),
                leading: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.4),
                          borderRadius: BorderRadius.circular(50)),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'misc/avatar/man.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Profile Settings',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Edit User Name',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 11),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.2),
                                hintText: "Enter name",
                                hintStyle: TextStyle(
                                    color: Colors.blue.withOpacity(0.6),
                                    fontWeight: FontWeight.normal),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.5, horizontal: 20),
                                border: InputBorder.none,
                                prefixIcon: Image.asset(
                                    'misc/icons/id-card.png',
                                    scale: 20),
                                suffixIcon:
                                    const Icon(Icons.save, color: Colors.blue)),
                          ),
                        )
                      ],
                    )),
              ),
              const ListTile(
                title: Text(
                  'Account Settings',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              _BuildListTile(
                  widget: ListTile(
                title: const Text(
                  'Privacy Settings',
                  style: TextStyle(color: Colors.blue),
                ),
                leading: Image.asset('misc/icons/settings.png', scale: 20),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right_rounded)),
              )),
              _BuildListTile(
                  widget: ListTile(
                title: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.blue),
                ),
                leading: Image.asset('misc/icons/3d-lock.png', scale: 20),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right_rounded)),
              )),
              _BuildListTile(
                  widget: ListTile(
                title: const Text(
                  'Payment Methods',
                  style: TextStyle(color: Colors.blue),
                ),
                leading: Image.asset('misc/icons/wallet.png', scale: 20),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right_rounded)),
              )),
              const Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Notification Settings',
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  )),
              _BuildListTile(
                  widget: ListTile(
                title: const Text(
                  'Show Notifications',
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Switch(
                    inactiveTrackColor: Colors.transparent,
                    activeTrackColor: Colors.blue,
                    value: isNotificationOn,
                    onChanged: (bool value) {
                      setState(() {
                        isNotificationOn = value;
                      });
                    }),
              )),
              const Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Language Settings',
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  )),
              ListTile(
                title: const Text(
                  'Default Device',
                  style: TextStyle(color: Colors.blue),
                ),
                leading: const Icon(
                  Icons.language,
                  color: Colors.orange,
                ),
                trailing: Switch(
                    activeTrackColor: Colors.blue,
                    value: isDeviceSelected,
                    onChanged: (bool value) {
                      setState(() {
                        isDeviceSelected = value;
                      });
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.all(1),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            label: const Text('About us',
                                style: TextStyle(color: Colors.purple)),
                            icon: const Icon(Icons.people),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            label: const Text('Log out',
                                style: TextStyle(color: Colors.purple)),
                            icon: const Icon(Icons.logout),
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget _BuildListTile({required Widget widget}) {
  return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.black.withOpacity(0.2), width: 0.2))),
          child: widget));
}

Widget _BuildContainer({required Widget widget}) {
  return Container(
    width: 130,
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(child: widget),
    ),
  );
}
