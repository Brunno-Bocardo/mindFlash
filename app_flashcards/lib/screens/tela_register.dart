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
  bool _obscureText = true;

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
                  'Sign Up Now',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 163, 67, 150),
                  ),
                ),
                const Text(
                  'Please fill the fields below to create an account',
                  textAlign: TextAlign.center,
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
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
                    obscureText: _obscureText,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _cadastrarUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Create Account', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?", style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontSize: 15)),
                      SizedBox(width: 5),
                      const Text("Log In", style: TextStyle(color:Color.fromARGB(255, 163, 67, 150), fontSize: 15)),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ) 
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
          backgroundColor: const Color.fromARGB(255, 255, 254, 255),
          title: const Text('Sucesso', 
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 124, 48, 114),
          )),
          content: const Text('Usuário cadastrado com sucesso!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8.0),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      );
    } catch (e) {

      if (!mounted) return; // Mesmo aqui

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 254, 255),
          title: const Text('Erro', 
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 124, 48, 114),
          )),
          content: Text(
            e is FirebaseAuthException && e.code == 'invalid-email'
            ? 'E-mail inválido. Por favor, verifique o formato do e-mail.'
            : 'Erro ao cadastrar usuário. Preencha os campos corretamente e tente novamente.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8.0),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }
  }
}