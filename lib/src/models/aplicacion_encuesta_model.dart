class AplicacionEncuesta {
  String? idEncuesta;
  List<QuestionA>? answers;
  AplicacionEncuesta(id) {
    idEncuesta = id;
    answers = [];
  }
}

class QuestionA {
  String? idQuestion;
  List<OptionRespuestaA>? optionRespuestas;
  QuestionA(String id) {
    idQuestion = id;
    optionRespuestas = [];
  }
}

class OptionRespuestaA {
  String? idORespuesta;
  OptionRespuestaA(String id) {
    idORespuesta = id;
  }
}
