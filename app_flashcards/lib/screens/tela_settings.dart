import 'package:app_flashcards/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 124, 48, 114),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'img/logo.png',
                  height: 50,
                ),
                Text(
                  'Settings', 
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 124, 48, 114)
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            Container(
              width: 370,
              height: 115,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color.fromARGB(255, 176, 72, 163)
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                  children: [
                    SizedBox(
                      width: 65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.account_circle, size: 35),
                          Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // email do usuário logado
                        // Text(
                        //   'Flávia Goes',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //   ),
                        // ),
                        Text(
                          FirebaseAuth.instance.currentUser?.email ?? 'Não autenticado',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                )
            ),
            const SizedBox(height: 20),
            Container(
              width: 370,
              height: 115,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color.fromARGB(255, 176, 72, 163)
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.info, size: 35),
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // email do usuário logado
                      Text(
                        'MindFlash',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Flashcard App',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Version 1.0',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ),

            const SizedBox(height: 100),
            
            ElevatedButton(
              onPressed: _showResetPasswordDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder( // borda arredondada
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                width: 200,
                height: 50,
                child: Row(
                  children: [
                    Icon(Icons.password, size: 30),
                    SizedBox(width: 20),
                    const Text(
                      'Mudar senha',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
            ),
            
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _showLogoutDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder( // borda arredondada
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                width: 200,
                height: 50,
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 30),
                    SizedBox(width: 20),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: _showDeleteAccountDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder( // borda arredondada
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                width: 200,
                height: 50,
                child: Row(
                  children: [
                    Icon(Icons.delete_forever_sharp, size: 30),
                    SizedBox(width: 20),
                    const Text(
                      'Delete Account',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (idx) {
          if (idx == 0) {
            context.go('/home');
          }
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              context.go('/');
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Tem certeza que deseja apagar sua conta? Essa ação é irreversível.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text('Apagar'),
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              try {
                await FirebaseAuth.instance.currentUser?.delete();
                if (!mounted) return;
                context.go('/');
              } on FirebaseAuthException catch (e) {
                if (!mounted) return;

                if (e.code == 'requires-recent-login') {
                  _showReauthDialog();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao apagar conta: ${e.message}')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showReauthDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reautenticação necessária'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              try {
                final user = FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(email: email, password: password);
                await user?.reauthenticateWithCredential(cred);
                if (!mounted) return;

                Navigator.of(context).pop();

                try {
                  await user?.delete();
                  if (!mounted) return;
                  context.go('/');
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao apagar conta: ${e.toString()}')),
                  );
                }
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro na reautenticação: ${e.toString()}')),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog() {
    final email = FirebaseAuth.instance.currentUser?.email;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Redefinir senha'),
        content: Text(
          email != null
              ? 'Um email de redefinição de senha será enviado para:\n$email'
              : 'Não foi possível obter o email do usuário.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: email == null
                ? null
                : () async {
                    Navigator.of(dialogContext).pop();
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email de redefinição enviado!')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao enviar email: $e')),
                      );
                    }
                  },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
