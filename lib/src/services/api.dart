import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'encuestas-server-rest-api.herokuapp.com/api/v1/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    print(data);
    return await http.post(
      Uri(path: fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(apiUrl) async {
    return await Uri.https(_url, apiUrl);
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}
