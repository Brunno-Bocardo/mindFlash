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
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instância do FirebaseAuth - para usar os métodos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('img/logo.png', height: 150),
                const Text(
                  'Log In Now',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 163, 67, 150),
                  ),
                ),
                const Text(
                  'Please login to continue using our app',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(164, 126, 126, 126), // cor da borda
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 149, 34, 134),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(164, 126, 126, 126), // cor da borda
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 149, 34, 134),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Forgot Password', style: TextStyle(color: Color.fromARGB(255, 118, 118, 118))),
                        onPressed: () => context.push('/forgot_password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _tentarLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Log In', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.push('/cadastro'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontSize: 15)),
                      SizedBox(width: 5),
                      const Text("Sign Up", style: TextStyle(color:Color.fromARGB(255, 163, 67, 150), fontSize: 15)),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tentarLogin() async {
    try {
      // tenta fazer o login com o e-mail e senha fornecidos -> compara diretamente no Firebase
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
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
