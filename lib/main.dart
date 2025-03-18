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
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiUrl = 'https://psgc.gitlab.io/api';
  List<Map<String, String>> regions = [];
  List provinces = [];
  List cities = [];
  //List municipalities = [];
  List barangay = [];

  bool isLoading = false;
  bool isProvincesLoading = false;
  bool isCitiesLoading = false;
  //bool isMunicipalitiesLoading = false;
  bool isBarangayLoading = false;

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

  void loadCities(String provinceCode) async {
    var url = Uri.parse(
      'https://psgc.gitlab.io/api/provinces/$provinceCode/cities/',
    );
    var response = await http.get(url);
    //Cities response body
    print("Cities status: ${response.statusCode}");
    if (response.statusCode == 200) {
      provinces.clear();
      var result = jsonDecode(response.body) as List;
      //print(result[9]['regionName']);
      result.forEach((item) {
        //rename this to the list to be populated
        cities.add({'code': item['code'], 'name': item['name']});
      });
    }
    setState(() {
      isCitiesLoading = true;
    });
  }

  void loadBarangay(String cityCode) async {
    var url = Uri.parse(
      'https://psgc.gitlab.io/api/cities/$cityCode/barangays/',
    );
    var response = await http.get(url);
    //Cities response body
    print("Barangay status: ${response.statusCode}");
    if (response.statusCode == 200) {
      provinces.clear();
      var result = jsonDecode(response.body) as List;
      //print(result[9]['regionName']);
      result.forEach((item) {
        //rename this to the list to be populated
        barangay.add({'code': item['code'], 'name': item['name']});
      });
    }
    setState(() {
      isBarangayLoading = true;
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
      appBar: AppBar(
        title: Text('HTTPs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Scrollbar(
                    child: DropdownMenu(
                      width: 225,
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
                        width: 225,
                        onSelected: (value) {
                          print(value);
                          if (value != null) {
                            loadCities(value.toString());
                          }
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
                    if (isCitiesLoading)
                    Scrollbar(
                      child: DropdownMenu(
                        width: 225,
                        onSelected: (value) {
                          print(value);
                          if (value != null) {
                            loadBarangay(value.toString());
                          }
                        },
                        dropdownMenuEntries:
                            cities.map((item) {
                              return DropdownMenuEntry(
                                value: item['code'],
                                label: item['name'].toString(),
                              );
                            }).toList(),
                      ),
                    ),
                    if (isBarangayLoading)
                    Scrollbar(
                      child: DropdownMenu(
                        width: 225,
                        onSelected: (value) {
                          print(value);
                        },
                        dropdownMenuEntries:
                            barangay.map((item) {
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