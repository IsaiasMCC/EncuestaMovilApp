import 'dart:ui';

import 'package:encuestas/src/models/encuesta_model.dart';
import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:encuestas/src/provider/encuesta_provider.dart';
import 'package:flutter/material.dart';

class EncuestaVista extends StatefulWidget {
  @override
  _EncuestaVistaState createState() => _EncuestaVistaState();
}

class _EncuestaVistaState extends State<EncuestaVista> {
  TextStyle style_pregunta = const TextStyle(
      fontSize: 15, letterSpacing: 1, fontWeight: FontWeight.normal);
  var color_fuente = new Color.fromRGBO(52, 73, 94, 1);
  @override
  Widget build(BuildContext context) {
    final encuesta = ModalRoute.of(context)?.settings.arguments as Encuesta;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_fuente,
        title: const Text('Encuesta'),
      ),
      body: FutureBuilder(
        future: getEncuesta('${encuesta.id}'),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _encuesta(snapshot.data);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _encuesta(Seccions seccions) {
    return PageView.builder(
      itemCount: seccions.sections.length,
      itemBuilder: (context, index) {
        final seccion = seccions.sections[index];
        return _seccion(seccion, index);
      },
    );
  }

  Widget _seccion(Section seccion, int nrosec) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
      itemCount: seccion.questions.length,
      itemBuilder: (context, index) {
        final pregunta = seccion.questions[index];
        return _card(context, pregunta, nrosec, index);
      },
    );
  }

  Widget _card(BuildContext context, Question question, int nrosec, int index) {
    return Center(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: listaOption(context, question, nrosec, index),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> listaOption(
      BuildContext context, Question question, int nrosec, int index) {
    List<Widget> lista = [
      Row(),
      SizedBox(height: 30),
      Text('   ${index + 1}.- ¿ ${question.name} ?', style: style_pregunta),
      SizedBox(height: 30),
    ];
    final listaOptions = question.optionRespuesta;
    for (var option in listaOptions) {
      lista.add(optionRespuesta(option));
      lista.add(const SizedBox(height: 20));
    }

    lista.add(SizedBox(height: 20));
    return lista;
  }

  Widget optionRespuesta(OptionRespuesta opcion) {
    Widget option = Center(
      child: Text(
        '*  ${opcion.value}',
      ),
    );
    return option;
  }
}
