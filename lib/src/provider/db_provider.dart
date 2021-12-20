import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:encuestas/src/models/encuestaModelSQ.dart';
export 'package:encuestas/src/models/encuestaModelSQ.dart';

class DBProvider {
  static Database? _database; //propiedad privada

  static final DBProvider db =
      DBProvider._(); // constructor privado, para que no se reinicialice

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB(); // debe devolver una instancia de base de datos
    return _database;
  }

  initDB() async {
    Directory documentsDirectory =
        await getApplicationDocumentsDirectory(); // obtner el path donde se va encontrar nuestra BD
    String path = join(documentsDirectory.path,
        'EncuestaSQLite.db'); //path completo de archivo donde se encuentr mi bd
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      //sii la bd ya existe devuelve la intancia de la bd creada
      await db.execute('CREATE TABLE Encuestas ('
          ' id STRING PRIMARY KEY,'
          ' encuesta TEXT,'
          ' estado TEXT'
          ')');
    });
  }

  // crear registros
  nuevaEncuestaRaw(int id, String json) async {
    final db = await database; // esperar hast que la base de dato este lista

    final res = await db?.rawInsert(
        "INSERT Into Encuestas (id, encuesta, tipo) "
        "VALUE ( ${id}, '${json}', '${''}' )");
    // if(res == 1){ print('___Insercion correcta___'+res.toString());}
    return res;
  }

  nuevaEncuesta(EncuestaModelQlite nuevoEncuesta) async {
    final db = await database;
    final res = db?.insert('Encuestas', nuevoEncuesta.toJson());
    // print('res'+res.toString());
    // if(res == 0){ print('___Insercion fallida___'+res.toString());}
    return res;
  }

//select
  Future<EncuestaModelQlite?> getEncuestasId(int id) async {
    final db = await database;
    final res = await db?.query('Encuestas',
        where: 'id = ?', whereArgs: [id]); //devuelve un mapa

    return res!.isEmpty ? EncuestaModelQlite.fromJson(res.first) : null;
  }

//lista todas las encuestas en una lista
Future<List<EncuestaModelQlite>> getTodoEncuestas( ) async {
  final db = await database;
  final res = await db?.query('Encuestas', ); //devuelve  un listado de mapas
  //necesito hacer un listdado de encuestas
  List<EncuestaModelQlite> list = res!.isNotEmpty
                                  ? res.map((e) => EncuestaModelQlite.fromJson(e)).toList()
                                  : [] ;
  
return list;
}


//listado por estado
Future<List<EncuestaModelQlite>> getEncuestasPorTipo( String  estado ) async {
  final db = await database;
  final res = await db?.rawQuery("SELECT * FROM Encuestas WHERE  estado='$estado'"); //devuelve  un listado de mapas
  //necesito hacer un listdado de encuestas
  List<EncuestaModelQlite> list = res!.isNotEmpty
                                  ? res.map((e) => EncuestaModelQlite.fromJson(e)).toList()
                                  : [] ;
  
return list;
}

//___ Update 
// devuelve la cantidad de updat que se realizaron
//  1 si hizo actualizacion, 0 si no lo hizo
Future<int?> updateEncuestas ( EncuestaModelQlite nuevaEncuesta ) async {
  final db = await database;
  final res = db?.update('Encuestas',  nuevaEncuesta.toJson(), where:  'id = ?', whereArgs:[nuevaEncuesta.id] );

  return res;// devuelve la cantidad de atualizaciones que se hizo

}

//devuelve  la cantidad de registros eliminados
Future<int?> deleteEncuestas(int id ) async {
  final db = await database;
  /// res devuelve la cantidad de reg eliminados
  /// si no ponemos  where id    borraria todo los registros pero seguiria la estructura ahi
  /// drop   borra todo todo
  final res = await db?.delete('Encuestas', where: 'id= ?', whereArgs: [id]);
  
return res;
}
Future<int?> deleteEncuestasALL(int id ) async {
  final db = await database;
  
  final res = await db?.rawDelete('DELETE FROM Encuestas');
  
return res;
}

}
