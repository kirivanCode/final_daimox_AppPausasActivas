import 'package:deimoxapp/screens/ColaboracionesScreen.dart';
import 'package:flutter/material.dart';
import 'package:deimoxapp/reusable_widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:deimoxapp/utilis/color_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordHidden = true;

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } catch (e) {
      debugPrint('Error al registrar: $e');
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } catch (e) {
      debugPrint('Error al iniciar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Autenticación',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                height: 650,
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
                        'Autenticarse',
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
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 25, 165, 69),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 25, 165, 69),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Registrar',
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
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  String _profileImage = "assets/images/xd.png";

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('perfiles')
          .doc(user!.uid)
          .get();
      if (userData.exists) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        _nombreController.text = data['nombre'] ?? '';
        _apellidoController.text = data['apellido'] ?? '';
        _edadController.text = data['edad']?.toString() ?? '';
        _generoController.text = data['genero'] ?? '';
        _pesoController.text = data['peso']?.toString() ?? '';
        _alturaController.text =
            (data['altura']?.toDouble() ?? 0.0).toStringAsFixed(2);
        setState(() {
          _profileImage = data['imagen'] ?? _profileImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Datos Guardados',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.3,
                  backgroundImage: AssetImage(_profileImage),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _edadController,
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _generoController,
                  decoration: const InputDecoration(
                    labelText: 'Género',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _pesoController,
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _alturaController,
                  decoration: const InputDecoration(
                    labelText: 'Altura',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _seleccionarImagen,
                      icon: const Icon(Icons.photo_camera),
                      color: Colors.white,
                      iconSize: 30.0,
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _guardarDatosEnFirestore,
                      child: const Text('Guardar Datos'),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ColaboracionesScreen()), // Navega a la pantalla de colaboraciones
                    );
                  },
                  icon: Image.asset(
                    'assets/images/xd.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Creadores de la app'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarImagen() async {
    // Implementa la selección de imagen entre hombre y mujer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset('assets/images/perfilH.png', width: 50),
                title: const Text('Hombre'),
                onTap: () {
                  setState(() {
                    _profileImage = 'assets/images/perfilH.png';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/perfilM.png', width: 50),
                title: const Text('Mujer'),
                onTap: () {
                  setState(() {
                    _profileImage = 'assets/images/perfilM.png';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _guardarDatosEnFirestore() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('perfiles')
          .doc(user!.uid)
          .set({
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'edad': int.tryParse(_edadController.text) ?? 0,
        'genero': _generoController.text,
        'peso': double.tryParse(_pesoController.text) ?? 0.0,
        'altura': double.tryParse(_alturaController.text) ?? 0.0,
        'imagen': _profileImage, // Guarda la ruta de la imagen seleccionada.
      });
    }
  }
}

class DatosGuardadosScreen extends StatelessWidget {
  const DatosGuardadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Si el usuario no está autenticado, redirigir a la pantalla de autenticación
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('perfiles')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text(
                'Error al cargar los datos',
                style: TextStyle(color: Colors.white, fontSize: 18),
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No hay datos guardados',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Crear Perfil'),
                  ),
                ],
              );
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 120.0,
                        backgroundImage: AssetImage(
                            data['imagen'] ?? 'assets/images/xd.png'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    buildInfoText('Correo', user.email ?? 'No disponible'),
                    buildInfoText('Nombre', data['nombre']),
                    buildInfoText('Apellido', data['apellido']),
                    buildInfoText('Edad', data['edad'].toString()),
                    buildInfoText('Género', data['genero']),
                    buildInfoText('Peso', '${data['peso']} kg'),
                    buildInfoText('Altura', '${data['altura']} mts'),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const Text('Editar Perfil'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
