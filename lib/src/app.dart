import 'package:encuestas/src/pages/Encuestas/encuesta_aplicar_page.dart';
import 'package:flutter/material.dart';
import 'package:encuestas/src/pages/home_page.dart';
import 'package:encuestas/src/pages/login_page.dart';
import 'package:encuestas/src/pages/register_page.dart';
import 'package:encuestas/src/pages/Encuestas/encuestas_card_pages.dart';
import 'package:encuestas/src/pages/Encuestas/encuesta_vista_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material',
      initialRoute: 'encuestas',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
        'register': (BuildContext context) => RegisterPage(),
        'encuestas': (BuildContext context) => EncuestaPage(),
        'aplicarencuestas': (BuildContext contex) => EncuestaAplicar(),
        'verencuestas': (BuildContext context) => EncuestaVista(),
      },
    );
  }
}
