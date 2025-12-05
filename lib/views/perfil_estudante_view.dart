import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/perfil_estudante_viewmodel.dart';

class PerfilEstudanteView extends StatelessWidget {
  const PerfilEstudanteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E8ED),
      appBar: AppBar(title: const Text('Perfil'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'Tela a ser desenvolvida',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Esta funcionalidade em breve estará disponível',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
