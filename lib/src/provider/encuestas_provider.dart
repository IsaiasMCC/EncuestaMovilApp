import 'dart:convert';

import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:encuestas/src/provider/db_provider.dart';

import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';


Future<List<Encuesta>> getEncuestas() async {

  Encuestas aux= new Encuestas();

   bool result = await InternetConnectionChecker().hasConnection;
  (result) ? print('hay internet') : print('No hay Internet....!! Lista de BDLocal');

  if(result) {
   //var state = DBProvider.db.getTodoPoll();
  Uri url = Uri.parse(
      'https://encuestas-server-rest-api.herokuapp.com/api/v1/encuestas');
  final res = await http.get(url);
  var cuerpo = res.body;
  
  var objeto = json.decode(cuerpo);
  //var success = (objeto['success']);
   print(objeto['encuestas']);
   var json1= jsonEncode(objeto['encuestas']);
  
   
   DBProvider.db.nuevoPoll( json1.toString());

   final encuestas = Encuestas.fromJsonList(objeto['encuestas']);

  var encuesta =await DBProvider.db.getMaxIDPoll(); //await DBProvider.db.getTodoPoll();
   print(obtnertotal(encuesta));
   
  
  //return encuestas.items;
  aux= encuestas;

  }
  else{

  print('No hay Internet....!! Lista de BDLocal');
  // Future<Seccions> getEncuestaLocal(id) async {
    var id =await DBProvider.db.getMaxIDPoll();
print(obtnertotal(id));
   var res = await DBProvider.db.getPollId(obtnertotal(id));// 1.toString());
   // var res = await DBProvider.db.getMaxIDPoll();
   var objeto1 = jsonDecode(res['encuesta']);
 print(objeto1);
   var encuestass = {"encuesta": objeto1};
//   // print(jsonEncode(sectionss));
  
   var encuesta = Encuestas.fromJsonList(objeto1);
//   return sections;
//}
    aux= encuesta;
    
  }
  //  var a = await DBProvider.db.getMaxIDPoll();
  //  print('ultimo   a');
  //  print(a);

  return aux.items;
  
}
String obtnertotal(dynamic cad){
   var x= cad.toString();
    
 //   print('**** Poll_ Db : '+max.toString());
 List<String> x1= x.split(' ');
 List<String> x2= x1[1].split(' ');
 List<String> x3= x2[0].split('}]');
 return x3[0];

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

