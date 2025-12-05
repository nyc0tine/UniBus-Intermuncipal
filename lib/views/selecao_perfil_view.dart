import 'package:flutter/material.dart';
import 'cadastro_estudante_view.dart';
import 'cadastro_motorista_view.dart';

class SelecaoPerfilView extends StatelessWidget {
  const SelecaoPerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBF3),

      body: Column(
        children: [
          // ------------------------ CABEÇALHO PADRÃO ------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF4C63B6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Center(
              child: Text(
                'SELECIONE O PERFIL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          // ------------------------ CONTEÚDO CENTRAL ------------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // Ícone central
                  const Icon(
                    Icons.person_pin_circle,
                    size: 90,
                    color: Color(0xFF4C63B6),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Como você deseja se cadastrar?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C63B6),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Escolha abaixo o tipo de conta.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // ------------------ CARTÃO ESTUDANTE ------------------
                  _buildCard(
                    context: context,
                    title: "Sou Estudante",
                    icon: Icons.school_rounded,
                    color: const Color(0xFF4C63B6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CadastroEstudanteView(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // ------------------ CARTÃO MOTORISTA ------------------
                  _buildCard(
                    context: context,
                    title: "Sou Motorista",
                    icon: Icons.directions_bus_rounded,
                    color: const Color(0xFF3A4A99),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CadastroMotoristaView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------ COMPONENTE DE CARTÃO ------------------------
  Widget _buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF4C63B6),
              offset: Offset(4, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 45, color: color),

            const SizedBox(width: 20),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: color,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
