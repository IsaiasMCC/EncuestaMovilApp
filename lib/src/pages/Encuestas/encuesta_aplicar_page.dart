import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:encuestas/src/provider/encuesta_provider.dart';
import 'package:encuestas/src/models/encuesta_model.dart';
import 'package:flutter/material.dart';
import 'package:encuestas/src/pages/Encuestas/alerta.dart';
import 'package:encuestas/src/models/almacenar_preguntas_model.dart';

class EncuestaAplicar extends StatefulWidget {
  const EncuestaAplicar({Key? key}) : super(key: key);

  @override
  _EncuestaAplicarState createState() => _EncuestaAplicarState();
}

class _EncuestaAplicarState extends State<EncuestaAplicar> {
  String? id = '';
  SeccionsM listaState = SeccionsM();
  var color_fuente = new Color.fromRGBO(52, 73, 94, 1);

  @override
  Widget build(BuildContext context) {
    final encuesta = ModalRoute.of(context)?.settings.arguments as Encuesta;
    listaState.id = encuesta.id;
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color_fuente,
          title: const Text('Aplicar Encuesta'),
          leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => alertaSalida(context),
          ),
        ),
        body: FutureBuilder(
          future: getEncuestaLocal('${encuesta.id}'),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return encuestaAplicar(snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget encuestaAplicar(Seccions seccions) {
    for (var i = 0; i < seccions.sections.length; i++) {
      PreguntasM pregs = PreguntasM();
      listaState.secciones!.add(pregs);
      var prs = seccions.sections[i].questions;

      for (var j = 0; j < prs.length; j++) {
        PreguntaM preg = PreguntaM('');
        pregs.preguntas!.add(preg);
        var pr = prs[j].optionRespuesta;

        if (!prs[j].multiple) {
          var resp = RespuestaM();
          preg.respuestas!.add(resp);
        }
        for (var k = 0; k < pr.length; k++) {
          if (prs[j].multiple) {
            var resp = RespuestaM();
            preg.respuestas!.add(resp);
            resp.idOpcionRespuesta = '';
          }
        }
      }
    }
    return PageView.builder(
        itemCount: seccions.sections.length,
        itemBuilder: (context, index) {
          final seccion = seccions.sections[index];
          PreguntasM pregs = PreguntasM();
          listaState.secciones!.add(pregs);
          return _seccion(seccion, index, seccions.sections.length, pregs);
        });
  }

  Widget _seccion(Section seccion, int nro, int length, PreguntasM pregs) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: seccion.questions.length,
        itemBuilder: (context, index) {
          final pregunta = seccion.questions[index];
          return Column(
            children: [
              _nombreSeccion(nro, length, index),
              cardPregunta(context, pregunta, index, nro),
              _botonEnviar(nro, length, index, seccion.questions.length),
            ],
          );
        });
  }

  Widget cardPregunta(
      BuildContext context, Question pregunta, int index, int nrosec) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: listaOption(context, pregunta, index, nrosec),
        ),
      ),
    );
  }

  List<Widget> listaOption(
      BuildContext context, Question question, int index, int nrosec) {
    List<Widget> lista = [
      Row(),
      const SizedBox(height: 30),
      Text('¿ ${question.name} ?'),
      const SizedBox(height: 30),
    ];
    //hasta aqui
    final listaOptions = question.optionRespuesta;
    final multiple = question.multiple;

    for (var i = 0; i < listaOptions.length; i++) {
      lista.add(optionRespuesta(
          listaOptions[i], multiple, question, index, i, nrosec));
      lista.add(const SizedBox(height: 20));
    }

    lista.add(SizedBox(height: 20));
    return lista;
  }

  Widget optionRespuesta(OptionRespuesta opcion, bool multiple,
      Question question, int index, int i, int nrosec) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 20,
        ),
        opcionSeleccion(opcion, multiple, question, index, i, nrosec),
        const SizedBox(
          width: 60,
        ),
        Text('${opcion.value}')
      ],
    );
  }

  Widget opcionSeleccion(OptionRespuesta opcion, bool multiple,
      Question respuesta, int index, int i, int nrosec) {
    if (multiple) {
      return Checkbox(
        value: listaState
            .secciones![nrosec].preguntas?[index].respuestas?[i].state,
        onChanged: (valor) {
          setState(() {
            listaState.secciones?[nrosec].preguntas?[index].respuestas?[i]
                .state = valor;
            listaState.secciones?[nrosec].preguntas?[index].respuestas?[i]
                .idOpcionRespuesta = opcion.id;
          });
        },
      );
    } else {
      int? val =
          listaState.secciones![nrosec].preguntas![index].respuestas![0].select;
      return Radio(
          value: i + 1,
          groupValue: val,
          onChanged: (int? valor) {
            setState(() {
              val = valor;
              listaState.secciones![nrosec].preguntas![index].respuestas![0]
                  .select = val;
              listaState.secciones![nrosec].preguntas![index].respuestas![0]
                  .idOpcionRespuesta = opcion.id;
            });
          });
    }
  }

  Widget _nombreSeccion(int index, int length, int questions) {
    if (questions == 0 && index == 0)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(''),
          Text(
            'Seccion ${index + 1}/${length}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      );
    else {
      if (questions == 0 && (index + 1 == length)) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_ios_sharp),
            Text(
              'Seccion ${index + 1}/${length}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            Text(''),
          ],
        );
      } else if (questions == 0 && index != 0 && index + 1 != length) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_ios_sharp),
            Text(
              'Seccion ${index + 1}/${length}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        );
      } else
        return Text('');
    }
  }

  Widget _botonEnviar(
      int index, int length, int questions, int lengthPregunta) {
    if (questions + 1 == lengthPregunta && (index + 1 == length)) {
      return MaterialButton(
        minWidth: 250.0,
        height: 40.0,
        color: Colors.blue,
        child: const Text('Guardar',
            style: TextStyle(
              backgroundColor: Colors.blue,
              color: Colors.white,
            )),
        onPressed: () {},
      );
    } else
      return Text('');
  }
}
