import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_navbar_estudante.dart';

class EnqueteView extends StatefulWidget {
  const EnqueteView({super.key});

  @override
  State<EnqueteView> createState() => _EnqueteViewState();
}

class _EnqueteViewState extends State<EnqueteView> {
  String? selecao;
  bool carregando = false;

  int _selectedIndex = 2;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushNamed(context, '/trajetosEstudante');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/homeEstudante');
    } else if (index == 2) {
      // já está na enquete
    }
  }

  final List<String> opcoes = [
    "Ida",
    "Volta",
    "Ida e Volta",
    "Não"
  ];

  Future<void> enviarResposta() async {
    if (selecao == null) {
      _showMessage("Escolha uma opção!");
      return;
    }

    final agora = DateTime.now();
    if (!(agora.hour >= 14 && agora.hour < 19)) {
      _showMessage("A enquete só pode ser respondida entre 14h e 19h.");
      return;
    }

    setState(() => carregando = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("enquetes")
          .doc(uid)
          .set({
        "resposta": selecao,
        "data": DateTime.now(),
      });

      _showMessage("Resposta enviada com sucesso!");
    } catch (e) {
      _showMessage("Erro ao enviar resposta: $e");
    }

    setState(() => carregando = false);
  }

  void _showMessage(String t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBF3),

      // ------------------ HEADER NOVO ------------------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF4C63B6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Botão voltar
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                // Título
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "ENQUETE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ------------------ CORPO ------------------
      body: Column(
        children: [
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Você usará o ônibus amanhã?\nEscolha abaixo:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 25),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: opcoes.length,
              itemBuilder: (_, i) {
                final opcao = opcoes[i];
                final selecionado = selecao == opcao;

                return GestureDetector(
                  onTap: () => setState(() => selecao = opcao),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? const Color(0xFF4C63B6)
                          : const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C63B6),
                          blurRadius: 4,
                          offset: Offset(4, 4),
                        )
                      ],
                    ),
                    child: Text(
                      opcao,
                      style: TextStyle(
                        color: selecionado ? Colors.white : Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: carregando ? null : enviarResposta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C63B6),
                minimumSize: const Size(260, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              child: carregando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "ENVIAR RESPOSTA",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
        ],
      ),

      // ------------------ NAVBAR ------------------
      bottomNavigationBar: CustomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
