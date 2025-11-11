import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700)); // simulate auth
    setState(() => _loading = false);
    // On success navigate to dashboard and replace login
    if (mounted) Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  void _showAvatarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final tmpCtrl = TextEditingController(text: _avatarCtrl.text);
        return AlertDialog(
          title: const Text('Masukkan URL foto'),
          content: TextField(
            controller: tmpCtrl,
            decoration: const InputDecoration(labelText: 'URL gambar'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                _avatarCtrl.text = tmpCtrl.text.trim();
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = _avatarCtrl.text.trim();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header/banner image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: theme.colorScheme.primary.withOpacity(0.12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _showAvatarDialog,
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                              backgroundImage: avatarUrl.isNotEmpty
                                  ? NetworkImage(avatarUrl) as ImageProvider
                                  : const AssetImage('assets/images/avatar_default.png'),
                              child: avatarUrl.isEmpty ? null : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Welcome Back', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 6),
                          Text('Masuk untuk melanjutkan', style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 14),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(labelText: 'Email'),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Email tidak valid';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _obscure = !_obscure),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                                    if (v.length < 6) return 'Minimal 6 karakter';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _avatarCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'URL Foto (opsional)',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.image),
                                      onPressed: _showAvatarDialog,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _submit,
                                    child: _loading
                                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                        : const Text('Masuk'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pushReplacementNamed('/dashboard'),
                                      child: const Text('Lanjut sebagai tamu'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
