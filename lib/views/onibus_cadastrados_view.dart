import 'package:flutter/material.dart';

import 'onibus_cadastro_view.dart';

class OnibusCadastradosView extends StatefulWidget {
  final List<Map<String, String>>? addedBuses;

  const OnibusCadastradosView({super.key, this.addedBuses});

  @override
  State<OnibusCadastradosView> createState() => _OnibusCadastradosViewState();
}

class _OnibusCadastradosViewState extends State<OnibusCadastradosView> {
  String? _selectedPlaca;
  List<Map<String, String>> _buses = [
    {
      'placa': 'EFD5G62',
      'capacidade': '45 PESSOAS',
      'tipo': 'ÔNIBUS',
      'marca': 'Marca A',
      'numero': '001',
    },
    {
      'placa': 'KTG6C15',
      'capacidade': '15 PESSOAS',
      'tipo': 'MICRO-ÔNIBUS',
      'marca': 'Marca B',
      'numero': '002',
    },
  ];

  @override
  void initState() {
    super.initState();
    // if the screen was opened with added buses, append them
    if (widget.addedBuses != null && widget.addedBuses!.isNotEmpty) {
      _buses.addAll(widget.addedBuses!);
      _selectedPlaca = widget.addedBuses!.last['placa'];
    }
  }

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

          // LISTA DE ÔNIBUS (mock) - toque para selecionar (scrollable)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _buses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final bus = _buses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPlaca = bus['placa']),
                    child: _cardOnibus(
                      placa: bus['placa'] ?? '',
                      capacidade: bus['capacidade'] ?? '',
                      tipo: bus['tipo'] ?? '',
                      selecionado: _selectedPlaca == bus['placa'],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCadastro() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const OnibusCadastroView()),
    );

    if (result != null) {
      setState(() {
        _buses.add(result);
        _selectedPlaca = result['placa'];
      });
    }
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
