import 'package:flutter/material.dart';

class ColaboracionesScreen extends StatelessWidget {
  const ColaboracionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colaboraciones'),
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
              'Brayan',
              'Backend y desarrollo',
              'assets/images/PerfilH.png',
            ),
            _buildCollaborationCard(
              context,
              'Gabriela Garcia',
              'Diseño e investigacion',
              'assets/images/PerfilM.png',
            ),
            _buildCollaborationCard(
              context,
              'Juan Andres',
              'ajustes de codigo y backeng',
              'assets/images/PerfilH.png',
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildCollaborationCard(BuildContext context, String title, String description, String imagePath) {
    return Card(
      color: const Color(0xFF1C1C1C),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Icon(
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
