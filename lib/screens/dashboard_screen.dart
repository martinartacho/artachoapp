import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    // Si no tenemos fecha de creación, cargar perfil
    if (authProvider.user != null && authProvider.user?.createdAt == null) {
      authProvider.loadUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final UserModel? user = authProvider.user;

    // Si el usuario cierra sesión o elimina cuenta mientras está en dashboard
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (user != null) ...[
              _buildUserInfoCard(user),
              const SizedBox(height: 30),
            ],
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(UserModel user) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoRow('Nombre:', user.name),
            _buildInfoRow('Email:', user.email),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menú',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        _buildMenuOption(
          context,
          icon: Icons.person,
          title: 'Perfil',
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        _buildMenuOption(
          context,
          icon: Icons.settings,
          title: 'Configuración',
          onTap: () {
            _showComingSoonMessage(context);
          },
        ),
        _buildMenuOption(
          context,
          icon: Icons.history,
          title: 'Historial',
          onTap: () {
            (context);
          },
        ),
        const Divider(height: 30),
        _buildMenuOption(
          context,
          icon: Icons.logout,
          title: 'Cerrar sesión',
          color: Colors.red,
          onTap: () {
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            authProvider.logout();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ],
    );
  }

  void _showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Estamos trabajando en esta función, próximamente estará funcional',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
