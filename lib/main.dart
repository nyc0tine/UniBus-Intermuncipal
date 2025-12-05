import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'viewmodels/login_viewmodel.dart';
import 'views/login_view.dart';
import 'firebase_options.dart';

import 'views/home_estudante_view.dart';
import 'views/home_motorista_view.dart';
import 'views/lista_estudante_view.dart';
import 'views/trajetos_motorista_view.dart';
import 'views/trajetos_estudante_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
      child: const UniBus(),
    ),
  );
}

class UniBus extends StatelessWidget {
  const UniBus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unibus Intermunicipal',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF4D61B0, {
          50: Color(0xFFF3F5FC),
          100: Color(0xFFE3E9F7),
          200: Color(0xFFCDD9F1),
          300: Color(0xFFB7C9EB),
          400: Color(0xFFA6BBE5),
          500: Color(0xFF4D61B0),
          600: Color(0xFF4659AA),
          700: Color(0xFF3D4DA3),
          800: Color(0xFF35419C),
          900: Color(0xFF273088),
        }),
      ),

      routes: {
        '/homeEstudante': (context) => const HomeEstudanteView(),
        '/homeMotorista': (context) => const HomeMotoristaView(),
        '/trjetosMotorista': (context) => const TrajetosMotoristaView(),
        '/trajetosEstudante': (context) => const TrajetosEstudanteView(),
        '/listaEstudantes': (context) => const ListaEstudanteView(),
      },
      home: const LoginView(),
    );
  }
}
