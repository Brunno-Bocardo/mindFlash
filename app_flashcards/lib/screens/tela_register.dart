import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth - para usar os métodos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // esse parâmetro cria aquela setinha de voltar
        title: const Text('Cadastro')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('LOGO AQUI', style: TextStyle(fontSize: 24)),
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
              onPressed: _cadastrarUsuario,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _cadastrarUsuario() async {
    try {
      // Tenta criar um novo usuário com o e-mail e senha fornecidos
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // Verifica se o widget ainda está montado antes de usar o BuildContext 
      // Isso é importante para evitar erros de contexto após a navegação em uma execução assíncrona
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Usuário cadastrado com sucesso!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/');
              },
            ),
          ],
        ),
      );
    } catch (e) {

      if (!mounted) return; // Mesmo aqui

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
            content: Text(
            e is FirebaseAuthException && e.code == 'invalid-email'
              ? 'E-mail inválido. Por favor, verifique o formato do e-mail.'
              : 'Erro ao cadastrar usuário. Preencha os campos corretamente e tente novamente.',
            ),
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