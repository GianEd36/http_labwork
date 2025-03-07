import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String island = 'island';
  late String region = 'region';
  late String provinces = 'provinces';
  final apiUrl = 'https://psgc.gitlab.io/api';

  List<Map<String, String>> regions = [];

  //late String provinces;
  void callAPI() async {
    var url = Uri.parse('island-groups/');

    var response = await http.get(url);
    print(response.statusCode);
    print(response.body);
    print(response.headers);
    island = response.body;
    setState(() {});
  }

  void loadRegions() async {
    var url = Uri.parse('${apiUrl}/regions/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body) as List;
      //print(result[9]['regionName']);
      result.forEach((item) {
        regions.add({'code': item['code'], 'name': item['name']});
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTTPs')),
      body: Column(
        children: [
          TextButton(onPressed: loadRegions, child: Text('Call api')),
          Scrollbar(
            child: DropdownMenu(
              dropdownMenuEntries:
                  regions.map((item) {
                    return DropdownMenuEntry(
                      value: item['code'],
                      label: item['name'].toString(),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
