import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'bayu sukma');
  final _email = TextEditingController(text: 'bayu@example.com');
  final _about = TextEditingController(text: 'Saya pengguna aplikasi ini.');
  final _avatar = TextEditingController(text: '');
  bool _initedArgs = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _about.dispose();
    _avatar.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        _name.text = args['name']?.toString() ?? _name.text;
        _email.text = args['email']?.toString() ?? _email.text;
        _about.text = args['about']?.toString() ?? _about.text;
        _avatar.text = args['avatar']?.toString() ?? _avatar.text;
      }
      _initedArgs = true;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final result = {'name': _name.text, 'email': _email.text, 'about': _about.text, 'avatar': _avatar.text};
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil tersimpan')));
    Navigator.of(context).pop(result);
  }

  void _editAvatarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final tmp = TextEditingController(text: _avatar.text);
        return AlertDialog(
          title: const Text('Ganti Foto (URL)'),
          content: TextField(controller: tmp, decoration: const InputDecoration(labelText: 'URL gambar')),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(onPressed: () {
              _avatar.text = tmp.text.trim();
              setState(() {});
              Navigator.of(context).pop();
            }, child: const Text('Simpan')),
          ],
        );
      },
    );
  }

  Widget _avatarWidget(double radius) {
    final theme = Theme.of(context);
    final url = _avatar.text.trim();
    if (url.isNotEmpty) {
      return CircleAvatar(radius: radius, backgroundImage: NetworkImage(url), backgroundColor: Colors.transparent);
    } else {
      // pakai asset default jika ada
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage('assets/images/avatar_default.png'),
        backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
        child: _name.text.trim().isEmpty ? Text('U', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)) : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    GestureDetector(onTap: _editAvatarDialog, child: _avatarWidget(36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_name.text, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(_email.text, style: theme.textTheme.bodyMedium),
                      ]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_outlined),
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                      tooltip: 'Logout',
                    )
                  ]),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(labelText: 'Nama'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email wajib';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _about,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Tentang saya'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _avatar,
                        decoration: InputDecoration(
                          labelText: 'URL Foto (opsional)',
                          suffixIcon: IconButton(icon: const Icon(Icons.image), onPressed: _editAvatarDialog),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _name.text = 'bayu sukma';
                                _email.text = 'bayu@example.com';
                                _about.text = 'Saya pengguna aplikasi ini.';
                                _avatar.text = '';
                                setState(() {});
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(onPressed: _save, child: const Text('Simpan')),
                          ),
                        ],
                      )
                    ]),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
