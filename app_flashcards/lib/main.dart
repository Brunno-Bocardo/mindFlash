import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // funções do Firebase
import 'firebase_options.dart'; // configurações do Firebase - criado no "$ flutterfire configure"
import 'package:go_router/go_router.dart';

// TELAS
import 'screens/tela_login.dart';
import 'screens/tela_home.dart';
import 'widgets/create_deck.dart';
import 'screens/tela_settings.dart';
import 'screens/tela_register.dart';
import 'screens/tela_forgot_password.dart';

void main() async {
  // Inicializa o Flutter e o Firebase
  // Garante que o Firebase seja inicializado antes de usar qualquer funcionalidade dele
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final nome = state.uri.queryParameters['nome'] ?? 'Usuário';
        return TelaPrincipal(nomeUsuario: nome);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/cadastro',
      builder: (context, state) => const TelaCadastro(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Login com GoRouter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}