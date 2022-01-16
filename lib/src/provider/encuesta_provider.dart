import 'dart:convert';
import 'package:encuestas/src/models/almacenar_preguntas_model.dart';
import 'package:encuestas/src/provider/db_provider.dart';
import 'package:encuestas/src/models/encuesta_model.dart';
import 'package:encuestas/src/models/aplicacion_encuesta_model.dart';
import 'package:http/http.dart' as http;

Future<Seccions> getEncuesta(id) async {
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas/$id');
  final res = await http.get(url);
  var cuerpo = res.body;
  var objeto = jsonDecode(cuerpo);
  var sectionss = {"sections": objeto['encuesta']['sections']};
  // print(jsonEncode(sectionss));
  var sections = seccionsFromJson(jsonEncode(sectionss));
  // var success = (objeto['success']);
  return sections;
}

Future<Seccions> getEncuestaLocal(id) async {
  var encuesta = await DBProvider.db.getEncuestasId(id);
  var objeto1 = jsonDecode(encuesta['encuesta']);
  // print(objeto1['sections']);
  var sectionss = {"sections": objeto1['sections']};
  // print(jsonEncode(sectionss));
  var sections = seccionsFromJson(jsonEncode(sectionss));
  return sections;
}

guardarEncuestaAplicada(SeccionsM seccions) {
  AplicacionEncuesta aplicada = AplicacionEncuesta(seccions.id);
  for (var i = 0; i < seccions.secciones!.length; i++) {
    var prs = seccions.secciones![i].preguntas;

    for (var j = 0; j < prs!.length; j++) {
      QuestionA pregunta = QuestionA(prs[j].id);
      var pr = prs[j].respuestas;

      for (var k = 0; k < pr!.length; k++) {}
    }
  }
}

descargarEncuesta(String? id) async {
  var state = DBProvider.db.getEncuestasStateId(id);
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas/$id');
  final res = await http.get(url);
  var cuerpo = res.body;
  var objeto = jsonDecode(cuerpo);
  var sectionss = {"sections": objeto['encuesta']['sections']};

  var json = jsonEncode(sectionss);
  state.then((value) => {
        if (!value) {DBProvider.db.nuevaEncuestaRaw(id, json.toString())}
      });
}

actualizarEncuesta(String? id) async {
  var state = DBProvider.db.getEncuestasStateId(id);
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas/$id');
  final res = await http.get(url);
  var cuerpo = res.body;
  var objeto = jsonDecode(cuerpo);
  var sectionss = {"sections": objeto['encuesta']['sections']};
  // var sectionss = objeto['encuesta']['sections'];

  var json = jsonEncode(sectionss);

  // print(json);
  state.then((value) async => {
        if (value)
          {await DBProvider.db.updateEncuestasLocal(id, json.toString())}
      });
}
