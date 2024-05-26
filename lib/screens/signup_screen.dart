import 'package:deimoxapp/reusable_widgets/reusable_widget.dart';
import 'package:deimoxapp/screens/inicio.dart';
import 'package:deimoxapp/utilis/color_utils.dart';
import 'package:deimoxapp/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _passwordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
        ),
        title: const Text(
          'Registro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de los íconos a blanco
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                hexStringToColor("000000"),
                hexStringToColor("000000"),
                hexStringToColor("161616")
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                height:
                    650, // Ajusta la altura para dejar espacio para el nuevo campo de nombre de usuario
                width: 325,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 24, 24, 24),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      logoWidget("assets/images/logo2.png"),
                      const SizedBox(height: 30),
                      const Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller:
                              _usernameController, // Vincula el controlador de texto al campo de entrada para el nombre de usuario
                          decoration: const InputDecoration(
                            labelText:
                                'Nombre de usuario', // Etiqueta para el campo de nombre de usuario
                            labelStyle: TextStyle(color: Colors.white),
                            suffixIcon: Icon(
                              FontAwesomeIcons.user,
                              size: 17,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            labelStyle: TextStyle(color: Colors.white),
                            suffixIcon: Icon(
                              FontAwesomeIcons.envelope,
                              size: 17,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(color: Colors.white),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordHidden = !_passwordHidden;
                                });
                              },
                              child: Icon(
                                _passwordHidden
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          obscureText: _passwordHidden,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          _register(); // Llama a la función _register para registrar al usuario
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 25, 165, 69),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((userCredential) {
      // Guarda el nombre de usuario en la base de datos después de que el usuario se haya registrado exitosamente
      _saveUsername(userCredential.user!.uid);
      // Navega a la pantalla de inicio después del registro exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Inicio()),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error de registro'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    });
  }

  void _saveUsername(String userId) {
    // Implementa aquí la lógica para guardar el nombre de usuario en la base de datos
    // Por ejemplo, podrías usar Firestore para guardar el nombre de usuario
    // Aquí hay un ejemplo simplificado usando Firestore:
    // FirebaseFirestore.instance.collection('users').doc(userId).set({'username': _usernameController.text});
  }
}
