import 'package:dmuh_net/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Меню',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: Text('Новини'),
                onTap: () {
                  launchUrlString('https://t.me/s/DmuhNet');
                },
              ),
              SizedBox(height: 550),
              const ListTile(
                title: Text(
                    style: TextStyle(color: Color.fromARGB(255, 106, 177, 224)),
                    'Версія: 1.0.0'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text(' DmuhNet'),
          centerTitle: true,
        ),
        body: const HomePage(),
      ),
    );
  }
}
