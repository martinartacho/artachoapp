import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/feedback_screen.dart';
// import 'package:flutter/foundation.dart'; // Para kReleaseMode
// import 'package:flutter/services.dart'; // Para rootBundle

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SOLUCIÓN SIMPLIFICADA - Funciona en debug y release
  await dotenv.load(fileName: "assets/.env");

  // print('🌍 API_BASE_URL: ${dotenv.env['API_BASE_URL']}');

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
          case '/feedback':
            return MaterialPageRoute(
              builder: (context) => const FeedbackScreen(),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = '${info.version}+${info.buildNumber}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const frase = 'Millor a poc a poc i bona lletra.';

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

            // ✅ Mostrar versión y frase
            Column(
              children: [
                Text(
                  '“$frase”',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Versió: $_version',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
