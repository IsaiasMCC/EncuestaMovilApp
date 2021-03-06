import 'dart:async';

import 'package:encuestas/src/provider/db_provider.dart';
import 'package:encuestas/src/provider/encuesta_provider.dart';
import 'package:encuestas/src/provider/encuestas_provider.dart';
import 'package:encuestas/src/models/encuestas_model.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
            icon: const Icon(Icons.send_to_mobile),
            tooltip: 'Enviando Aplicaciones',
            onPressed: () async{
              //print('enviando');
                  bool result = await InternetConnectionChecker().hasConnection;
                  if(result) {
                  var value =  enviarAplicacion(); 
                          
                          showToast(context, 'Enviando Encuesta $value');
                          
                          print(value);                           
                        
                  // enviarAplicacion();
                  // showToast(context, 'Enviando Encuestas');
                }
                else{
                   showToast(context, 'Sin Conexion');
                }


            }
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar encuestas',
            onPressed: () {
              Navigator.pushNamed(context, 'encuestas');
            },
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
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
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
              leading: const Icon(Icons.analytics, color: Colors.orange),
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
                    Navigator.pushNamed(context, 'verencuestas',
                        arguments: encuesta);
                  },
                ),
                TextButton(
                  child: Text('aplicar', style: TextStyle(color: color_fuente)),
                  onPressed: () {
                    Navigator.pushNamed(context, 'aplicarencuestas',
                        arguments: encuesta);
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.green,
                  ),
                  tooltip: 'Encuesta Descargada',
                  onPressed: () {
                    
                    descargarEncuesta(encuesta.id).then((value)=>{
                      if(value){
                        showToast(context, 'Descargando Encuesta')
                        
                      }
                      else{
                        showToast(context, 'Sin Conexion')
                      },
                      print(value)

                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                  ),
                  tooltip: 'Encuesta Actualizada',
                  onPressed: () {

                    actualizarEncuesta(encuesta.id).then((value)=>{
                      if(value){
                        showToast(context, 'Actualizando Encuesta')
                        
                      }
                      else{
                        showToast(context, 'Sin Conexion')
                      },
                      print(value)

                    });

                    
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  enviarAplicacion(){
    var aux=0;
    enviarAplicacionEncuesta().then(
      (res) => {
      print('hola $res'),
      
      aux= res
       

    }
      
    );

    return aux;

  }

  Future cliclo() async {
    Future timeout = Future.delayed(const Duration(seconds: 5));
    return timeout.timeout(const Duration(seconds: 10), onTimeout: () {
      print('hola');
    });
  }

  void showToast(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: 
      Text(mensaje,
      style: TextStyle(
           fontSize: 20,  
           color: Colors.red, 
           

           //fontStyle: FontStyle.italic 
        ) ,
      ),
      duration: Duration(seconds: 3),
    ));
  }


}
