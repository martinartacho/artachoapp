import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'my_app.dart'; // Ajusta según tu estructura

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(prefs: prefs),
      child: const MyApp(),
    ),
  );
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print(
    '🌍 API_BASE_URL: ${dotenv.env['API_BASE_URL']}',
  ); // ✅ Aquí sí es válido

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(prefs: prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      // Usar onGenerateRoute para manejar mejor las redirecciones
      onGenerateRoute: (settings) {
        // Si el usuario no está autenticado y trata de acceder a rutas protegidas
        if (!authProvider.isAuthenticated &&
            ['/dashboard', '/profile'].contains(settings.name)) {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        }

        // Rutas definidas
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => authProvider.isAuthenticated
                  ? const DashboardScreen()
                  : const HomeScreen(),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            );
          case '/dashboard':
            return MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => authProvider.isAuthenticated
                  ? const DashboardScreen()
                  : const HomeScreen(),
            );
        }
      },
      initialRoute: '/',
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artacho App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👋 Hola 👋', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Entrar'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Registrarse'),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
              child: const Text('Recuperar contraseña'),
            ),
            const SizedBox(height: 40),

            // ✅ Frase para identificar versión
            const Text(
              '📝 Versió: “Amb paciència i amb salivera…”',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
