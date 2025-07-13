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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 124, 48, 114),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
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

                const SizedBox(height: 25),

                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.15,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // email do usuário logado
                              Text(
                                'Email do usuário:',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                FirebaseAuth.instance.currentUser?.email ?? 'Não autenticado',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 15, 
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.15,
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
                                fontSize: 13,
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
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Flashcard App',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Version 1.0',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),

                const SizedBox(height: 25),
                
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
                          'Change Password',
                          style: TextStyle(
                              fontSize: 15,
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
                              fontSize: 15,
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
                              fontSize: 15,
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
        )
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
        backgroundColor: const Color.fromARGB(255, 255, 254, 255),
        title: Text('Log Out Account', style: TextStyle(
              fontSize: 22,
              color: Color.fromARGB(255, 124, 48, 114),
            ),
          ),
        content: const Text('Deseja realmente sair?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
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
            child: const Text('Confirmar', style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 254, 255),
        title: const Text('Delete Account', style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 124, 48, 114),
            )),
        content: const Text('Tem certeza que deseja apagar sua conta? Essa ação é irreversível.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 15),
            ),
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Confirmar', style: TextStyle(fontSize: 15),
            ),
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
        backgroundColor: const Color.fromARGB(255, 255, 254, 255),
        title: const Text('Account Authentication', 
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 124, 48, 114),
          )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
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
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
              labelText: 'Password',
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
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 15),
            ),
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Confirmar', style: TextStyle(fontSize: 15),
            ),
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
        backgroundColor: const Color.fromARGB(255, 255, 254, 255),
        title: const Text('Redefine Password', 
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 124, 48, 114),
          )),
        content: Text(
          email != null
              ? 'E-mail de redefinição de senha será enviado para: $email'
              : 'Não foi possível obter o email do usuário.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Cancelar', style: TextStyle(fontSize: 15),
            ),
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 176, 72, 163),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8.0),
            ),
            child: const Text('Enviar', style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
