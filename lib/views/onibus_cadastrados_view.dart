import 'package:flutter/material.dart';
import 'onibus_cadastro_view.dart';

class OnibusCadastradosView extends StatelessWidget {
  const OnibusCadastradosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECF2),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF445CC4),
        child: const Icon(Icons.add, size: 32),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OnibusCadastroView()),
          );
        },
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF445CC4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  "Ônibus Cadastrados",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LISTA DE ÔNIBUS (mock)
          _cardOnibus(
            placa: "EFD5G62",
            capacidade: "45 PESSOAS",
            tipo: "ÔNIBUS",
            selecionado: true,
          ),

          const SizedBox(height: 20),

          _cardOnibus(
            placa: "KTG6C15",
            capacidade: "15 PESSOAS",
            tipo: "MICRO-ÔNIBUS",
            selecionado: false,
          ),
        ],
      ),
    );
  }

  Widget _cardOnibus({
    required String placa,
    required String capacidade,
    required String tipo,
    required bool selecionado,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selecionado ? Icons.radio_button_checked : Icons.circle_outlined,
            size: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PLACA:\n$placa", style: const TextStyle(fontSize: 18)),
                Text("\nCAPAC.: $capacidade", style: const TextStyle(fontSize: 18)),
                Text("\nTIPO: $tipo", style: const TextStyle(fontSize: 18)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
