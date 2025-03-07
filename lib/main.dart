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
  final apiUrl = 'https://psgc.gitlab.io/api';
  List<Map<String, String>> regions = [];
  List provinces = [];
  bool isLoading = false;
  bool isProvincesLoading = false;

  void loadRegions() async {
    isLoading = true;
    var url = Uri.parse('${apiUrl}/regions/');
    var response = await http.get(url);
    print("Regions status: ${response.statusCode}");
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body) as List;
      //print(result[9]['regionName']);
      result.forEach((item) {
        regions.add({'code': item['code'], 'name': item['name']});
      });
    }
    setState(() {});
    isLoading = false;
  }

  void loadProvinces(String regionCode) async {
    var url = Uri.parse(
      'https://psgc.gitlab.io/api/regions/$regionCode/provinces/',
    );
    var response = await http.get(url);
    print("Provinces status: ${response.statusCode}");
    if (response.statusCode == 200) {
      provinces.clear();
      var result = jsonDecode(response.body) as List;
      //print(result[9]['regionName']);
      result.forEach((item) {
        provinces.add({'code': item['code'], 'name': item['name']});
      });
    }
    setState(() {
      isProvincesLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();

    loadRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTTPs')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Scrollbar(
                    child: DropdownMenu(
                      onSelected: (value) {
                        print(value);
                        loadProvinces(value.toString());
                        if (value != null) {
                          loadProvinces(value.toString());
                        }
                      },
                      dropdownMenuEntries:
                          regions.map((item) {
                            return DropdownMenuEntry(
                              value: item['code'],
                              label: item['name'].toString(),
                            );
                          }).toList(),
                    ),
                  ),
                  if (isProvincesLoading)
                    Scrollbar(
                      child: DropdownMenu(
                        onSelected: (value) {
                          print(value);
                        },
                        dropdownMenuEntries:
                            provinces.map((item) {
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
