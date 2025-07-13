import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}


class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  'New Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 163, 67, 150),
                  ),
                ),
                const Text(
                  'Please fill the field below with your e-mail',
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
                const SizedBox(height: 40), 
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Send E-mail', style: TextStyle(fontSize: 20)),
                    
                  ),
                ),     
                
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already define a new password?", style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontSize: 15)),
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

  void _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 254, 255),
          title: const Text('Sucesso', 
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 124, 48, 114),
          )),
          content: const Text('E-mail de redefinição de senha enviado.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 254, 255),
          title: const Text('Erro', 
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 124, 48, 114),
          )),
          content: Text('Erro ao enviar e-mail de redefinição de senha.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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