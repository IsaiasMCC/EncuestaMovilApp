import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encuestas/src/pages/home_page.dart';
import 'package:encuestas/src/pages/login_page.dart';
import 'package:encuestas/src/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nombreController = new TextEditingController();
  TextEditingController direccionController = new TextEditingController();
  TextEditingController generoController = new TextEditingController();
  TextEditingController correoController = new TextEditingController();
  TextEditingController confirmarController = new TextEditingController();
  TextEditingController contrasenaController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondo = Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    return Stack(
      children: [
        fondo,
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 40.0,
            ),
          ),
          Container(
            width: size.width * 0.80,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  ),
                ]),
            child: Column(
              children: [
                Text(
                  'Registrate',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 30.0),
                _crearNombre(),
                SizedBox(height: 10.0),
                _crearTelefono(),
                SizedBox(height: 10.0),
                _crearEmail(),
                SizedBox(height: 10.0),
                _creardireccion(),
                SizedBox(height: 10.0),
                _crearGenero(),
                SizedBox(height: 10.0),
                _crearContrasena(),
                SizedBox(height: 10.0),
                _crearConfirmarContrasena(),
                SizedBox(height: 30.0),
                _crearBoton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: correoController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
          hintText: 'Correo electronico',
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: nombreController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.person, color: Colors.deepPurple),
          hintText: 'Nombre',
        ),
      ),
    );
  }

  Widget _crearTelefono() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: telefonoController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.phone, color: Colors.deepPurple),
          hintText: 'Telefono',
        ),
      ),
    );
  }

  Widget _creardireccion() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: direccionController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.location_city, color: Colors.deepPurple),
          hintText: 'Direccion',
        ),
      ),
    );
  }

  Widget _crearGenero() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: generoController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.people, color: Colors.deepPurple),
          hintText: 'Genero',
        ),
      ),
    );
  }

  Widget _crearContrasena() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: contrasenaController,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
          hintText: 'Contraseña',
        ),
      ),
    );
  }

  Widget _crearConfirmarContrasena() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: confirmarController,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
          hintText: 'Confirmar Contraseña',
        ),
      ),
    );
  }

  Widget _crearBoton() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Registrar'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: _register,
    );
  }

  void _register() async {
    var data = {
      'nombre': nombreController.text,
      'telefono': telefonoController.text,
      'correo': correoController.text,
      'direccion': direccionController.text,
      'genero': generoController.text,
      'contrasena': contrasenaController.text
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      print(data);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginPage()));
    } else
      print(body);
  }
}
