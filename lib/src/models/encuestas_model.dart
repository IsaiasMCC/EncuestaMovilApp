
class Encuestas {
  List<Encuesta> items = [];

  Encuestas();

  Encuestas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final encuesta =  Encuesta.fromJsonMap(item);
      items.add(encuesta);
    }
  }
}

class Encuesta {
  String? id;
  String? name;
  String? description;
  List<dynamic>? sections;
  String? fechaModificacion;
  String? fechaCreacion;

  Encuesta({
    this.id,
    this.name,
    this.description,
    this.sections,
    this.fechaModificacion,
    this.fechaCreacion,
  });

  Encuesta.fromJsonMap(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    sections = json['sections'];
    fechaModificacion = json['fecha_modificacion'];
    fechaCreacion = json['fecha_creacion'];
  }
}
