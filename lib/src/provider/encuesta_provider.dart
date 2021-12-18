import 'dart:convert';

import 'package:encuestas/src/models/encuesta_model.dart';
import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:http/http.dart' as http;

Future<Seccions> getEncuesta(id) async {
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas/$id');
  final res = await http.get(url);
  var cuerpo = res.body;
  var objeto = jsonDecode(cuerpo);
  var sectionss = {"sections": objeto['encuesta']['sections']};

  var sections = seccionsFromJson(jsonEncode(sectionss));
  // var success = (objeto['success']);
  return sections;
}
