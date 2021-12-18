import 'package:encuestas/src/provider/encuestas_provider.dart';
import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:flutter/material.dart';

class EncuestaPage extends StatefulWidget {
  @override
  _EncuestaPageState createState() => _EncuestaPageState();
}

class _EncuestaPageState extends State<EncuestaPage> {
  var color_fuente = new Color.fromRGBO(52, 73, 94, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuestas'),
        backgroundColor: color_fuente,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar encuestas',
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: getEncuestas(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _encuestas(snapshot.data);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _encuestas(List<Encuesta> encuestas) {
    return ListView.builder(
      padding: const  EdgeInsets.symmetric(vertical: 50, horizontal: 15),
      itemCount: encuestas.length,
      itemBuilder: (BuildContext context, index) {
        final encuesta = encuestas[index];
        return _card(context, encuesta);
      },
    );
  }


  Widget _card(BuildContext context, Encuesta encuesta) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.analytics, color: Colors.orange),
              title: Text('${encuesta.name}'),
              subtitle: Text('${encuesta.description}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('ver encuesta',
                      style: TextStyle(color: color_fuente)),
                  onPressed: () {
                    Navigator.pushNamed(context, 'verencuestas', arguments: encuesta);
                  },
                ),
                TextButton(
                  child: Text('aplicar', style: TextStyle(color: color_fuente)),
                  onPressed: () {
                    Navigator.pushNamed(context, 'aplicarencuestas', arguments:  encuesta);
                  },
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
