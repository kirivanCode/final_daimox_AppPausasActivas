import 'package:deimoxapp/models/exercise.dart';
import 'package:deimoxapp/screens/timer_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  final List<Exercise> exercises = [
    Exercise(
        name: "Flexion de rodilla de pie con apoyo",
        description:
            "Colóquese de pie con los pies anchura de los hombros frente a una silla. Coja la silla con ambas manos. Doble la rodilla derecha moviendo el talón hacia arriba. Vuelva a la posición inicial con un suave movimiento.",
        imagePath: "assets/images/pasiva1.png"),
    Exercise(
        name: "Flexion plantar y dorsiflexion",
        description:
            "Siéntese en una silla alta, sus pies no deben tocar el suelo. Moviendo solo el tobillo, levante la punta del pie derecho tanto como pueda.",
        imagePath: "assets/images/pasiva2.png"),
    Exercise(
        name: "Abducción de cadera con apoyo en silla",
        description:
            "Colóquese de pie con los pies anchura de los hombros frente a una silla. Coja la silla con ambas manos. Separe su pie derecho del otro tanto como pueda. Exhale durante el movimiento.",
        imagePath: "assets/images/pasiva3.png"),
    Exercise(
        name: "Eversión e inversión",
        description:
            "Mueva la planta del pie derecho hacia arriba por su lado derecho y después por su lado izquierdo. Repita el movimiento la cantidad especificada de repeticiones y luego repita con el otro pie.",
        imagePath: "assets/images/pasiva4.png"),
    Exercise(
        name: "Flexión de rodilla auto asistida",
        description:
            "Con la ayuda de la pierna derecha, doble la rodilla izquierda tanto como pueda. Repita el movimiento la cantidad especificada de repeticiones, luego cambie de lado y repita el ejercicio.",
        imagePath: "assets/images/pasiva5.png"),
    Exercise(
        name: "Extensión de pierna sentado",
        description:
            "Extienda completamente la rodilla izquierda mientras exhala. Vuelva a la posición inicial con un suave movimiento mientras inhala y alterne con la otra pierna.",
        imagePath: "assets/images/pasiva6.png"),
    Exercise(
        name: "Hiperextensión de rodilla apoyada",
        description:
            "Siéntese en una silla y coloque otra silla frente a usted. Su trasero debe estar en contacto con el respaldo de la silla. Extienda completamente la rodilla derecha y coloque el talón en la silla frente a usted.",
        imagePath: "assets/images/pasiva7.png"),
    Exercise(
        name: "Isométrico cuádriceps sentado",
        description:
            "Empuje el suelo principalmente con los talones. Mantenga la tensión durante el tiempo requerido. Relaje los músculos y repita el ejercicio.",
        imagePath: "assets/images/pasiva8.png"),
    Exercise(
        name: "Elevación de talones de pie apoyado",
        description:
            "Usando las pantorrillas, levante los talones lo más alto que pueda mientras exhala. Asegúrese de que sólo mueve los tobillos. Vuelva a la posición inicial con un suave movimiento mientras inhala. Mantenga la columna vertebral recta.",
        imagePath: "assets/images/pasiva9.png"),
    Exercise(
        name: "Extensión de pierna sentado",
        description:
            "Extienda completamente la rodilla izquierda mientras exhala. Vuelva a la posición inicial con un suave movimiento mientras inhala y alterne con la otra pierna.",
        imagePath: "assets/images/pasiva11.png"),
    Exercise(
        name: "Estiramiento femoral sentado",
        description:
            "siéntate en el suelo con las piernas extendidas y te inclinas hacia adelante desde las caderas, manteniendo la espalda recta, para estirar los músculos del muslo.",
        imagePath: "assets/images/pasiva10.png"),
    // Agregar más ejercicios según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ejercicios de Pausas Pasivas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Cambia el color de la flecha de devolver a blanco
          size: 30, // Aumenta el tamaño para hacerla más prominente
        ),
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Image.asset(
                    exercises[index].imagePath,
                    width: 60,
                    height: 60,
                  ),
                  title: Text(
                    exercises[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      exercises[index].description,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerScreen(
                          exercises: exercises,
                          exerciseIndex: index,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
