import 'package:flutter/material.dart';

import 'onibus_cadastrados_view.dart';

class OnibusCadastroView extends StatefulWidget {
  const OnibusCadastroView({super.key});

  @override
  State<OnibusCadastroView> createState() => _OnibusCadastroViewState();
}

class _OnibusCadastroViewState extends State<OnibusCadastroView> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();

  @override
  void dispose() {
    _numeroController.dispose();
    _marcaController.dispose();
    _placaController.dispose();
    _tipoController.dispose();
    _capacidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECF2),
      body: SingleChildScrollView(
        child: Column(
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
                    "CADASTRO",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _input("Número", _numeroController),
            _input("Marca", _marcaController),
            _input("Placa do Ônibus", _placaController),
            _input("Tipo", _tipoController),
            _input("Capacidade", _capacidadeController),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF445CC4),
                minimumSize: const Size(250, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                final numero = _numeroController.text.trim();
                final marca = _marcaController.text.trim();
                final placa = _placaController.text.trim();
                final tipo = _tipoController.text.trim();
                final capacidade = _capacidadeController.text.trim();

                if (placa.isEmpty || marca.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha pelo menos Marca e Placa')));
                  return;
                }

                // Navega para a tela de ônibus cadastrados, passando o novo ônibus
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OnibusCadastradosView(
                      addedBuses: [
                        {
                          'numero': numero,
                          'marca': marca,
                          'placa': placa,
                          'tipo': tipo,
                          'capacidade': capacidade,
                        }
                      ],
                    ),
                  ),
                );
              },
              child: const Text(
                "CADASTRAR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
