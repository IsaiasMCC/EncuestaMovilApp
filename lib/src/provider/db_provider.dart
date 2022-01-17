import 'dart:io';
import 'package:flutter/cupertino.dart';
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
          ' id TEXT PRIMARY KEY,'
          ' encuesta TEXT'
          ')');
      await db.execute('CREATE TABLE Aplicacions ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'aplicacion TEXT'
          ')');
    });
  }

  // crear registros
  nuevaEncuestaRaw(String? id, String encuesta) async {
    final db = await database; // esperar hast que la base de dato este lista

    final res = await db?.rawInsert("INSERT Into Encuestas (id, encuesta) "
        "VALUES ( '$id', '$encuesta')");
    // if(res == 1){ print('___Insercion correcta___'+res.toString());}
    return res;
  }

  //guardar encuesta aplicada
  nuevaAplicacionEncuesta(String aplicacionE) async {
    final db = await database;
    final res = await db?.rawInsert("INSERT Into Aplicacions (aplicacion) "
        "VALUES ('$aplicacionE')");
    return res;
  }

   getAplicacionEncuesta() async {
    final db = await database;
    final res = db?.query('Aplicacions');
    return res;
  }

  deleteAplicacionEncuesta(int id) async {
    final db = await database;
    final res =
        await db?.delete('Aplicacions', where: 'id= ?', whereArgs: [id]);

    return res;
  }

  updateEncuestasLocal(String? id, String encuesta) async {
    final db = await database;
    final res = db?.rawQuery(
        "UPDATE Encuestas set encuesta = ? WHERE id = ?", [encuesta, id]);

    return res; // devuelve la cantidad de atualizaciones que se hizo
  }

//select
  getEncuestasId(String id) async {
    final db = await database;
    final res = await db?.query('Encuestas',
        where: 'id = ?', whereArgs: [id]); //devuelve un mapa

    return res!.isNotEmpty ? res.first : null;
  }

  Future<bool> getEncuestasStateId(String? id) async {
    final db = await database;
    final res = await db?.query('Encuestas',
        where: 'id = ?', whereArgs: [id]); //devuelve un mapa
// EncuestaModelQlite.fromJson(res.first)
    return res!.isNotEmpty ? true : false;
  }

//lista todas las encuestas en una lista
  getTodoEncuestas() async {
    final db = await database;
    final res = await db?.query(
      'Encuestas',
    ); //devuelve  un listado de mapas
    //necesito hacer un listdado de encuestas
    // List<EncuestaModelQlite> list = res!.isNotEmpty
    //     ? res.map((e) => EncuestaModelQlite.fromJson(e)).toList()
    //     : [];

    return res!;
  }

//listado por estado
  Future<List<EncuestaModelQlite>> getEncuestasPorTipo(String estado) async {
    final db = await database;
    final res = await db?.rawQuery(
        "SELECT * FROM Encuestas WHERE  estado='$estado'"); //devuelve  un listado de mapas
    //necesito hacer un listdado de encuestas
    List<EncuestaModelQlite> list = res!.isNotEmpty
        ? res.map((e) => EncuestaModelQlite.fromJson(e)).toList()
        : [];

    return list;
  }

//___ Update
// devuelve la cantidad de updat que se realizaron
//  1 si hizo actualizacion, 0 si no lo hizo
  Future<int?> updateEncuestas(EncuestaModelQlite nuevaEncuesta) async {
    final db = await database;
    final res = db?.update('Encuestas', nuevaEncuesta.toJson(),
        where: 'id = ?', whereArgs: [nuevaEncuesta.id]);

    return res; // devuelve la cantidad de atualizaciones que se hizo
  }

//devuelve  la cantidad de registros eliminados
  Future<int?> deleteEncuestas(int id) async {
    final db = await database;

    /// res devuelve la cantidad de reg eliminados
    /// si no ponemos  where id    borraria todo los registros pero seguiria la estructura ahi
    /// drop   borra todo todo
    final res = await db?.delete('Encuestas', where: 'id= ?', whereArgs: [id]);

    return res;
  }

  Future<int?> deleteEncuestasALL(int id) async {
    final db = await database;

    final res = await db?.rawDelete('DELETE FROM Encuestas');

    return res;
  }
}
