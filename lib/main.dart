import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ViewModels
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/usuario_viewmodel.dart';

// Views
import 'views/login_view.dart';
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
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioViewModel()), // se usar reset de senha
      ],
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
        useMaterial3: true, // ATIVAR MATERIAL 3
        colorSchemeSeed: const Color(0xFF4D61B0),
        fontFamily: "Roboto",
      ),

      // ROTAS
      routes: {
        '/homeEstudante': (context) => const HomeEstudanteView(),
        '/homeMotorista': (context) => const HomeMotoristaView(),
        '/trajetosMotorista': (context) => const TrajetosMotoristaView(),
        '/trajetosEstudante': (context) => const TrajetosEstudanteView(),
        '/listaEstudantes': (context) => const ListaEstudanteView(),
      },

      home: const LoginView(),
    );
  }
}
