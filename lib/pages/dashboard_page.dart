import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _name = 'bayu sukma';
  String _email = 'bayu@example.com';
  String _about = 'Saya pengguna aplikasi ini.';
  String _avatarUrl = ''; // kosong = tampilkan inisial

  Future<void> _openProfile() async {
    final result = await Navigator.of(context).pushNamed(
      '/profile',
      arguments: {'name': _name, 'email': _email, 'about': _about, 'avatar': _avatarUrl},
    );
    if (result != null && result is Map) {
      setState(() {
        _name = result['name']?.toString() ?? _name;
        _email = result['email']?.toString() ?? _email;
        _about = result['about']?.toString() ?? _about;
        _avatarUrl = result['avatar']?.toString() ?? _avatarUrl;
      });
    }
  }

  Widget _avatar(BuildContext context, {double radius = 18}) {
    final theme = Theme.of(context);
    if (_avatarUrl.isNotEmpty) {
      return CircleAvatar(radius: radius, backgroundImage: NetworkImage(_avatarUrl), backgroundColor: Colors.transparent);
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage('assets/images/avatar_default.png'),
        backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
        child: _name.trim().isEmpty ? Text('U', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)) : null,
      );
    }
  }

  Widget _featureCard(BuildContext c, IconData icon, String title, String subtitle, VoidCallback onTap) {
    final theme = Theme.of(c);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 28, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ]),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada notifikasi'))),
          ),
          IconButton(
            icon: _avatar(context, radius: 14),
            onPressed: _openProfile,
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  _avatar(context, radius: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Halo, $_name!', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(_email, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      Text(_about, style: theme.textTheme.bodySmall),
                    ]),
                  ),
                  ElevatedButton.icon(
                    onPressed: _openProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profil'),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _featureCard(context, Icons.analytics, 'Statistik', 'Lihat ringkasan performa', () {}),
                  _featureCard(context, Icons.message, 'Pesan', 'Cek percakapan terbaru', () {}),
                  _featureCard(context, Icons.settings, 'Pengaturan', 'Atur preferensi aplikasi', () {}),
                  _featureCard(context, Icons.help_outline, 'Bantuan', 'Panduan dan FAQ', () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu Bantuan')));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/home');
        },
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
