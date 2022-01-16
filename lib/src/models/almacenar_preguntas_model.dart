class SeccionsM {
  String? id;
  List<PreguntasM>? secciones;
  SeccionsM() {
    secciones = [];
    id = '';
  }
}

class PreguntasM {
  List<PreguntaM>? preguntas;
  PreguntasM() {
    preguntas = [];
  }
}

class PreguntaM {
  String? id;
  List<RespuestaM>? respuestas;
  PreguntaM(idd) {
    id = idd;
    respuestas = [];
  }
}

class RespuestaM {
  String? idOpcionRespuesta;
  bool? state;
  int? select;
  RespuestaM() {
    idOpcionRespuesta = '';
    state = false;
    select = -1;
  }
}
