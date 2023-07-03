import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:regres/models.dart';

class ApiServices extends ChangeNotifier {
  List<Data> dataList = [];

  Future<void> getDataApi() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      List<dynamic> users = data['data'];
      dataList = users.map((user) => Data.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load data');
    }
    notifyListeners(); // Notify listeners of state change
  }
}
