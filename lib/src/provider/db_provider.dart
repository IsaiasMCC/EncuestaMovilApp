import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:encuestas/src/models/encuestaModelSQ.dart';
export 'package:encuestas/src/models/encuestaModelSQ.dart';
class DBProvider {

  static Database? _database; //propiedad privada

 static final DBProvider db=
  DBProvider._(); // constructor privado, para que no se reinicialice

   DBProvider._();

   Future< Database? > get database async {
    if (_database != null) return _database;
    _database = await initDB(); // debe devolver una instancia de base de datos
    return _database;
  }

  initDB() async {
    Directory  documentsDirectory = await getApplicationDocumentsDirectory(); // obtner el path donde se va encontrar nuestra BD
    String path = join(documentsDirectory.path,'EncuestaSQLite.db');//path completo de archivo donde se encuentr mi bd
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int  version) async {
        //sii la bd ya existe devuelve la intancia de la bd creada
         await db.execute(
           'CREATE TABLE Encuestas ('
           ' id INTEGER PRIMARY KEY,'
           ' encuesta TEXT,'
           ' estado TEXT'
           ')'

         );
      }
      );
  }

  // crear registros
  nuevaEncuestaRaw( EncuestaModelQlite nuevoEncuesta ) async {

    final db = await database;// esperar hast que la base de dato este lista
    
    final res =  await db.rawInsert(
      "INSERT Into Encuestas (id, encuesta, tipo) "
      "VALUE ( ${ nuevoEncuesta.id }, '${ nuevoEncuesta.encuesta }', '${ nuevoEncuesta.estado }' )"      
    );
   // if(res == 1){ print('___Insercion correcta___'+res.toString());}
  return res; 
    
  }
  
nuevaEncuesta ( EncuestaModelQlite nuevoEncuesta) async {
  final db = await database;
  final res = db.insert('Encuestas', nuevoEncuesta.toJson());
  // print('res'+res.toString());
  // if(res == 0){ print('___Insercion fallida___'+res.toString());}
  return res;
}







}// END class
