import 'package:flutter/material.dart';

class ColaboracionesScreen extends StatelessWidget {
  const ColaboracionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Colaboraciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF203A43),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            _buildCollaborationCard(
              context,
              'Ivan Sierra',
              'Backend y desarrollo',
              'assets/images/xd.png',
            ),
            _buildCollaborationCard(
              context,
              'Brayan Javier Becerra Sandoval',
              'Backend y desarrollo',
              'assets/images/perfilH.png',
            ),
            _buildCollaborationCard(
              context,
              'Gabriela Garcia',
              'Diseño e investigacion',
              'assets/images/perfilM.png',
            ),
            _buildCollaborationCard(
              context,
              'Juan Andres',
              'Ajustes de código y backend',
              'assets/images/perfilH.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollaborationCard(BuildContext context, String title,
      String description, String imagePath) {
    return Card(
      color: const Color(0xFF1C1C1C),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            );
          },
        ),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onTap: () {
          // Acción al tocar la tarjeta
        },
      ),
    );
  }
}
