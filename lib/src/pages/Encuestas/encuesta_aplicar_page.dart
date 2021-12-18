import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:encuestas/src/provider/encuesta_provider.dart';
import 'package:encuestas/src/models/encuesta_model.dart';
import 'package:flutter/material.dart';
import 'package:encuestas/src/pages/Encuestas/alerta.dart';

class EncuestaAplicar extends StatefulWidget {
  const EncuestaAplicar({Key? key}) : super(key: key);

  @override
  _EncuestaAplicarState createState() => _EncuestaAplicarState();
}

class _EncuestaAplicarState extends State<EncuestaAplicar> {
  bool? _check = false;
  String? id = '';
  var color_fuente = new Color.fromRGBO(52, 73, 94, 1);
  @override
  Widget build(BuildContext context) {
    final encuesta = ModalRoute.of(context)?.settings.arguments as Encuesta;
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
          future: getEncuesta('${encuesta.id}'),
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
    return PageView.builder(
        itemCount: seccions.sections.length,
        itemBuilder: (context, index) {
          final seccion = seccions.sections[index];
          return _seccion(seccion, index, seccions.sections.length);
        });
  }

  Widget _seccion(Section seccion, int nro, int length) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: seccion.questions.length,
        itemBuilder: (context, index) {
          final pregunta = seccion.questions[index];
          return Column(
            children: [
              _nombreSeccion(nro, length, index),
              cardPregunta(context, pregunta),
              _botonEnviar(nro, length, index, seccion.questions.length),
            ],
          );
        });
  }

  Widget cardPregunta(BuildContext context, Question pregunta) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: listaOption(context, pregunta),
        ),
      ),
    );
  }

  List<Widget> listaOption(BuildContext context, Question question) {
    List<Widget> lista = [
      Row(),
      const SizedBox(height: 30),
      Text('¿ ${question.name} ?'),
      const SizedBox(height: 30),
    ];
    final listaOptions = question.optionRespuesta;
    final multiple = question.multiple;
    for (var option in listaOptions) {
      lista.add(optionRespuesta(option, multiple, listaOptions));
      lista.add(const SizedBox(height: 20));
    }

    lista.add(SizedBox(height: 20));
    return lista;
  }

  Widget optionRespuesta(OptionRespuesta opcion, bool multiple,
      List<OptionRespuesta> listaOptions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 20,
        ),
        opcionSeleccion(opcion, multiple),
        const SizedBox(
          width: 60,
        ),
        Text('${opcion.value}')
      ],
    );
  }

  Widget opcionSeleccion(OptionRespuesta opcion, bool multiple) {
    if (multiple) {
      return Checkbox(
        value: _check,
        onChanged: (valor) {
          setState(() {
            _check = valor;
          });
        },
      );
    } else {
      return Radio(
          value: opcion.id,
          groupValue: id,
          onChanged: (String? valor) {
            setState(() {
              id = valor;
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
