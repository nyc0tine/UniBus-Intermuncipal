import 'package:flutter/material.dart';
import '../widgets/custom_navbar_estudante.dart';

class TrajetosEstudanteView extends StatefulWidget {
  const TrajetosEstudanteView({super.key});

  @override
  State<TrajetosEstudanteView> createState() => _TrajetosEstudanteViewState();
}

class _TrajetosEstudanteViewState extends State<TrajetosEstudanteView> {

int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      // já está na página Trajetos
    } else if (index == 1) {
      Navigator.pushNamed(context, '/homeEstudante');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/listaEstudantes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E8ED),

      // ------------------ HEADER PADRONIZADO ------------------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF445CC4),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "MEUS TRAJETOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // ------------------ CORPO ------------------
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 90, color: Colors.grey[400]),
            const SizedBox(height: 25),
            Text(
              'Tela a ser desenvolvida',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta funcionalidade estará disponível em breve',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),

      // ------------------ NAVBAR ------------------
      bottomNavigationBar: CustomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
