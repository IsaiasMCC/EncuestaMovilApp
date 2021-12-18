// To parse this JSON data, do
//
//     final seccions = seccionsFromJson(jsonString);

import 'dart:convert';

Seccions seccionsFromJson(String str) => Seccions.fromJson(json.decode(str));

String seccionsToJson(Seccions data) => json.encode(data.toJson());

class Seccions {
  Seccions({
    required this.sections,
  });

  List<Section> sections;

  factory Seccions.fromJson(Map<String, dynamic> json) => Seccions(
        sections: List<Section>.from(
            json["sections"]?.map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
      };
}

class Section {
   Section({
    required this.name,
    required this.questions,
    required this.state,
  });

  String name;
  List<Question> questions;
  bool state;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        name: json["name"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "state": state,
      };
}

class Question {
  Question({
    this.name = '',
    required this.tipoPregunta,
    required this.optionRespuesta,
    required this.multiple,
  });

  String name;
  TipoPregunta tipoPregunta;
  List<OptionRespuesta> optionRespuesta;
  bool multiple;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        name: json["name"],
        tipoPregunta: TipoPregunta.fromJson(json["tipoPregunta"]),
        optionRespuesta: List<OptionRespuesta>.from(
            json["optionRespuesta"].map((x) => OptionRespuesta.fromJson(x))),
        multiple: json["multiple"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "tipoPregunta": tipoPregunta.toJson(),
        "optionRespuesta":
            List<dynamic>.from(optionRespuesta.map((x) => x.toJson())),
        "multiple": multiple,
      };
}

class OptionRespuesta {
  OptionRespuesta({
    required this.id,
    required this.value,
  });

  String id;
  String value;

  factory OptionRespuesta.fromJson(Map<String, dynamic> json) =>
      OptionRespuesta(
        id: json["_id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "value": value,
      };
}

class TipoPregunta {
  TipoPregunta({
    required this.name,
    required this.type,
  });

  String name;
  int type;

  factory TipoPregunta.fromJson(Map<String, dynamic> json) => TipoPregunta(
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
      };
}
