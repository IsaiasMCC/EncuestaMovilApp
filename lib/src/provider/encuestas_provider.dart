import 'dart:convert';

import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:encuestas/src/provider/db_provider.dart';

import 'package:http/http.dart' as http;

Future<List<Encuesta>> getEncuestas() async {
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas');
  final res = await http.get(url);
  var cuerpo = res.body;
  
  var objeto = json.decode(cuerpo);
  var success = (objeto['success']);
  // print(objeto['encuestas']);
  final encuestas = Encuestas.fromJsonList(objeto['encuestas']);
  return encuestas.items;
}


Future<List<Encuesta>> getEncuestasLocal() async {
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas');
  final res = await http.get(url);
  var cuerpo = res.body;

  var objeto = json.decode(cuerpo);
  var success = (objeto['success']);
  // print(objeto['encuestas']);
  final encuestas = Encuestas.fromJsonList(objeto['encuestas']);
  return encuestas.items;
}

