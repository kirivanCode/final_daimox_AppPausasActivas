import 'package:deimoxapp/screens/ColaboracionesScreen.dart';
import 'package:deimoxapp/screens/MusicScreen.dart';
import 'package:deimoxapp/screens/clock/alarma.dart';
import 'package:deimoxapp/screens/clock_screen.dart';
import 'package:deimoxapp/screens/exer_cuerpo.dart';
import 'package:flutter/material.dart';
import 'package:deimoxapp/screens/signin_screen.dart';
import 'package:deimoxapp/screens/home_screen.dart';
import 'package:deimoxapp/screens/exer_pasivos.dart';
import 'package:deimoxapp/screens/profile_screen.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 17, 49, 35),
              Color.fromARGB(255, 42, 42, 42),
              Color.fromARGB(255, 2, 3, 3),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Menú',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ejercicios de Pausas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconColumn(context, 'assets/images/activas.png',
                              'Activas', const HomeScreen()),
                          _buildIconColumn(context, 'assets/images/cuerpo.png',
                              'Cuerpo', const HomeScreen3()),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconColumn(context, 'assets/images/pasivas.png',
                              'Pasivas', const HomeScreen2()),
                          _buildIconColumn(context, 'assets/images/alarma.png',
                              'Alarma', const AlarmApp()),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconColumn(context, 'assets/images/perfil.png',
                              'Perfil', const DatosGuardadosScreen()),
                          _buildIconColumn(
                              context,
                              'assets/images/cerrar-sesion.png',
                              'Salir',
                              const SignInScreen()),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconColumn(BuildContext context, String imagePath,
      String description, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => targetScreen,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF717171), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
