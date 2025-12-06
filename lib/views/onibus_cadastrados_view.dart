import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'onibus_cadastro_view.dart';

class OnibusCadastradosView extends StatefulWidget {
  const OnibusCadastradosView({super.key});

  @override
  State<OnibusCadastradosView> createState() => _OnibusCadastradosViewState();
}

class _OnibusCadastradosViewState extends State<OnibusCadastradosView> {
  String? _selectedPlaca;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECF2),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF445CC4),
        child: const Icon(Icons.add, size: 32),
        onPressed: () {
          _openCadastro();
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
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Ônibus Cadastrados",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('onibus')
                  .orderBy('dataCadastro', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum ônibus cadastrado'));
                }

                final docs = snapshot.data!.docs;
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>;

                    final placa = (data['placa'] ?? '') as String;
                    final capacidade = (data['capacidade'] ?? '') as String;
                    final tipo = (data['tipo'] ?? '') as String;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedPlaca = placa);
                          Navigator.pop(context, placa); // <-- RETORNO
                        },
                        child: _cardOnibus(
                          placa: placa,
                          capacidade: capacidade,
                          tipo: tipo,
                          selecionado: _selectedPlaca == placa,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OnibusCadastroView()),
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
        children: [
          Icon(
            selecionado
                ? Icons.radio_button_checked
                : Icons.circle_outlined,
            size: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PLACA:\n$placa", style: const TextStyle(fontSize: 18)),
                Text("\nCAPACIDADE: $capacidade",
                    style: const TextStyle(fontSize: 18)),
                Text("\nTIPO: $tipo", style: const TextStyle(fontSize: 18)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
