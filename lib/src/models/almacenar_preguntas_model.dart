// class PreguntaM {
//   String idPregunta = '';
//   Map respuestas = {'id_opcionRespuesta': '', 'id_opcionRespuestas': []};
// }

// class EncuestaM {
//   String idEncuesta = '';
//   List<PreguntaM> encuesta = [];
// }

class Respuestas {
  List<RespuestaM> respuestas = [];

  Respuestas(int cantidad) {
    for (var i = 0; i < cantidad; i++) {
      final respuesta = RespuestaM();
      respuestas.add(respuesta);
    }
  }
}

class RespuestaM {
  String idOpcionRespuesta = '';
  int num = 0;
}
