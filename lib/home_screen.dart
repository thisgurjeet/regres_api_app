import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:regres/model/models.dart';
import 'package:http/http.dart' as http;

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Data> dataList = [];

  Future<List<Data>> getDataApi() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      List<dynamic> users = data['data'];
      dataList = users.map((user) => Data.fromJson(user)).toList();
      return dataList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.blue.shade100,
        title: const Text(
          'Regres Api',
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Data>>(
              future: getDataApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return Card(
                        // color: Colors.blue.shade100,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(data.avatar ?? ''),
                            ),
                            title: Text(data.email ?? ''),
                            subtitle: Text(
                                '${data.firstName ?? ''} ${data.lastName ?? ''}'),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
