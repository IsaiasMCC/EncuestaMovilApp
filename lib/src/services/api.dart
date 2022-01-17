import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'encuestas-server-rest-api.herokuapp.com/api/v1/';
  final url = Uri.parse('https://encuestas-server-rest-api.herokuapp.com');

  postData(data, apiUrl) async {
    // var fullUrl = _url + apiUrl + await _getToken();
    return await http.post(url,
        body: jsonEncode(data), headers: _setHeaders());
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
