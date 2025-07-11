import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth - para usar os métodos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MindFlash')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'img/logo.png',
              height: 200,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tentarLogin,
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Cadastre-se'),
                  onPressed: () => context.push('/cadastro'),
                ),
                const SizedBox(width: 20),
                TextButton(
                  child: const Text('Esqueci minha senha'),
                  onPressed: () => context.push('/forgot_password')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _tentarLogin() async {
    try {
      // tenta fazer o login com o e-mail e senha fornecidos -> compara diretamente no Firebase
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      if (!mounted) return;

      context.go('/home?nome=${userCredential.user?.email}');
    } catch (e) {
      // vê se o widget ainda está montado antes de usar o BuildContext
      if (!mounted) return;

      // popup se o login falhar
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Erro ao fazer login. Verifique seus dados.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  
}