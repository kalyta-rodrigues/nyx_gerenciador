import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final int minSenha = 4;
  final int maxSenha = 8;

  bool mostrarSenha = false;
  bool mostrarConfirmarSenha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/plano_fundo4.png", fit: BoxFit.cover),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Text(
                    "CRIAR CONTA",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildField("Nome completo", controller: nomeController),
                  const SizedBox(height: 20),

                  _buildField("E-mail", controller: emailController),
                  const SizedBox(height: 20),

                  _buildField(
                    "Senha",
                    isPassword: true,
                    controller: senhaController,
                    maxLength: maxSenha,
                    mostrar: mostrarSenha,
                    onToggle: () {
                      setState(() => mostrarSenha = !mostrarSenha);
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    "Confirmar senha",
                    isPassword: true,
                    controller: confirmarSenhaController,
                    maxLength: maxSenha,
                    mostrar: mostrarConfirmarSenha,
                    onToggle: () {
                      setState(
                        () => mostrarConfirmarSenha = !mostrarConfirmarSenha,
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF7812),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        final nome = nomeController.text.trim();
                        final email = emailController.text.trim();
                        final senha = senhaController.text.trim();
                        final confirmar = confirmarSenhaController.text.trim();

                        if (nome.isEmpty ||
                            email.isEmpty ||
                            senha.isEmpty ||
                            confirmar.isEmpty) {
                          _erro("Preencha todos os campos");
                          return;
                        }

                        if (senha.length < minSenha) {
                          _erro(
                            "A senha deve ter no mínimo $minSenha caracteres",
                          );
                          return;
                        }

                        if (senha.length > maxSenha) {
                          _erro(
                            "A senha deve ter no máximo $maxSenha caracteres",
                          );
                          return;
                        }

                        if (senha != confirmar) {
                          _erro("As senhas não coincidem");
                          return;
                        }

                        Navigator.pop(context, {
                          "email": email,
                          "senha": senha,
                        });
                      },
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Já possui conta? Voltar",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _erro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // CAMPO PERSONALIZADO
  Widget _buildField(
    String label, {
    required TextEditingController controller,
    bool isPassword = false,
    int? maxLength,
    bool mostrar = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !mostrar : false,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        counterText: "",

        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  mostrar ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: onToggle,
              )
            : null,

        hintText: label,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black45,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
