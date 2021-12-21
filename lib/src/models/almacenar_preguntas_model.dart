// class PreguntaM {
//   String idPregunta = '';
//   Map respuestas = {'id_opcionRespuesta': '', 'id_opcionRespuestas': []};
// }



class PreguntasM {
  String? idEncuesta = '';
  List<PreguntaM> encuesta = [];
}

class PreguntaM {
  String idPregunta = '';
  bool multiple = false;
  List<RespuestaM> respuestas = [];

  PreguntaM(String id, bool tipo) {
    idPregunta = id;
    multiple = tipo;
  }
}

class RespuestaM {
  String? idOpcionRespuesta = '';
  bool? estado = false;
}
