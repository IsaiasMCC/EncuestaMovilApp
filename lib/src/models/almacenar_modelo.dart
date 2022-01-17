// To parse this JSON data, do
//
//     final aplicacionEncuesta = aplicacionEncuestaFromJson(jsonString);

import 'dart:convert';

AplicacionEncuestaDB aplicacionEncuestaDBFromJson(String str) =>
    AplicacionEncuestaDB.fromJson(json.decode(str));

String aplicacionEncuestaDBToJson(AplicacionEncuestaDB data) =>
    json.encode(data.toJson());

class AplicacionEncuestaDB {
  AplicacionEncuestaDB({
    required this.idEncuesta,
    required this.answers,
  });

  String? idEncuesta;
  List<Answer> answers;

  factory AplicacionEncuestaDB.fromJson(Map<String, dynamic> json) =>
      AplicacionEncuestaDB(
        idEncuesta: json["id_encuesta"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_encuesta": idEncuesta,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}

class Answer {
  Answer({
    required this.idQuestion,
    required this.idOptionRespuesta,
  });

  String? idQuestion;
  List<String?> idOptionRespuesta;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        idQuestion: json["id_question"],
        idOptionRespuesta:
            List<String>.from(json["id_option_respuesta"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id_question": idQuestion,
        "id_option_respuesta":
            List<dynamic>.from(idOptionRespuesta.map((x) => x)),
      };
}
