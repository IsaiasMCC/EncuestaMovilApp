import 'dart:convert';
import 'package:encuestas/src/models/almacenar_modelo.dart';
import 'package:encuestas/src/models/almacenar_preguntas_model.dart';
import 'package:encuestas/src/provider/db_provider.dart';
import 'package:encuestas/src/models/encuesta_model.dart';
import 'package:encuestas/src/models/aplicacion_encuesta_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<Seccions> getEncuesta(id) async {
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas/$id');
  final res = await http.get(url);
  var cuerpo = res.body;
  var objeto = jsonDecode(cuerpo);
  var sectionss = {"sections": objeto['encuesta']['sections']};
    //print( 'hola____________'+jsonEncode(sectionss));
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
  AplicacionEncuestaDB aplicada2 =
      AplicacionEncuestaDB(idEncuesta: seccions.id, answers: []);
  // aplicada2.idEncuesta = seccions.id;
  for (var i = 0; i < seccions.secciones!.length; i++) {
    var prs = seccions.secciones![i].preguntas;

    for (var j = 0; j < prs!.length; j++) {
      QuestionA pregunta = QuestionA(prs[j].id);
      Answer pregunta2 = Answer(idQuestion: prs[j].id, idOptionRespuesta: []);
      // pregunta2.idQuestion = prs[j].id;
      aplicada.answers!.add(pregunta);
      aplicada2.answers.add(pregunta2);

      var pr = prs[j].respuestas;

      for (var k = 0; k < pr!.length; k++) {
        if (pr.length == 1 && pr[k].idOpcionRespuesta != '') {
          OptionRespuestaA oRespuesta =
              OptionRespuestaA(pr[k].idOpcionRespuesta);
          pregunta.optionRespuestas!.add(oRespuesta);

          pregunta2.idOptionRespuesta.add(pr[k].idOpcionRespuesta);
        } else if (pr[k].state == true) {
          OptionRespuestaA oRespuesta =
              OptionRespuestaA(pr[k].idOpcionRespuesta);
          pregunta.optionRespuestas!.add(oRespuesta);

          pregunta2.idOptionRespuesta.add(pr[k].idOpcionRespuesta);
        }
      }
    }
  }

  // print(aplicada.answers![0].optionRespuestas!.length);
  var json = (jsonEncode(aplicada2.toJson()));
  print(json);
  var state = DBProvider.db.nuevaAplicacionEncuesta(json.toString());
  state.then((res) => {print(res)});
}

Future<int> enviarAplicacionEncuesta() async {
  var select = DBProvider.db.getAplicacionEncuesta();
  Uri url;
  var json;
  var res;
  var ht;
  int s;
  String ms;
  var  aux= 0;
  
    // print('Hay connection');
    select.then((respuestas) async => {
          print(respuestas.length),
         aux = respuestas.length,
         print('encuesta Enviada   $aux'),
          for (var apli in respuestas)
            {
              json = jsonDecode(apli['aplicacion']),
              json = {"answers": json},
              // print(json),
              url = Uri.parse(
                  'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestaaplicadas'),
              ht = await http.post(
                url,
                headers: {
                  "Accept": "application/json",
                  'Content-type': 'application/json',
                },
                body: jsonEncode(json),
              ),
              print(ht.statusCode ),
              if (ht.statusCode == 200){
                  DBProvider.db.deleteAplicacionEncuesta(apli['id']),
                  print('delete')
              }
              
            }
    });
   //      print('aux2   $aux');
    return aux;
  
}

verifConnection() async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result) {
    print('Hay connection');
    return true;
  } else {
    print('No internet');
    return false;
  }
}

Future<bool> descargarEncuesta(String? id) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if(result){
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
  return result;
}

Future<bool> actualizarEncuesta(String? id) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if(result){
  var state = DBProvider.db.getEncuestasStateId(id);
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas/$id');
  final res = await http.get(url);
  var cuerpo = res.body;
  var objeto = jsonDecode(cuerpo);
  var sectionss = {"sections": objeto['encuesta']['sections']};
  // var sectionss = objeto['encuesta']['sections'];

  var json = jsonEncode(sectionss);

  print(json);
  state.then((value) async => {
        if (value)
          {await DBProvider.db.updateEncuestasLocal(id, json.toString())}
      });

  }     
  return  result;
}
