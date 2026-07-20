import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/user_model.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_text_field.dart';
import '../../../../../widgets/common/user_avatar.dart';
import '../providers/profile_provider.dart';

class ManageProfileScreen extends ConsumerStatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  ConsumerState<ManageProfileScreen> createState() =>
      _ManageProfileScreenState();
}

class _ManageProfileScreenState extends ConsumerState<ManageProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController(text: '081234567890');
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _initFromUser(UserModel user) {
    if (_initialized) return;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _bioController.text = user.bio ?? '';
    _initialized = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSaving = false);
    context.showSnackBar('Profil berhasil diperbarui');
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(profileProvider);

    return AppPageScaffold(
      title: 'Manage Profile',
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (resultValue) => switch (resultValue) {
          result.Success(:final data) => _buildForm(data),
          result.Error(:final failure) => Center(child: Text(failure.message)),
        },
      ),
    );
  }

  Widget _buildForm(UserModel user) {
    _initFromUser(user);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            UserAvatar(
              name: user.name,
              imageUrl: user.avatarUrl,
              radius: 48,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () =>
                  context.showSnackBar('Fitur upload foto segera hadir'),
              icon: const Icon(Iconsax.camera),
              label: const Text('Ubah Foto'),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap',
              prefixIcon: Iconsax.user,
              validator: (v) =>
                  v == null || v.length < 3 ? 'Nama minimal 3 karakter' : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'nama@email.com',
              prefixIcon: Iconsax.sms,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _phoneController,
              label: 'Nomor Telepon',
              hint: '08xxxxxxxxxx',
              prefixIcon: Iconsax.call,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _bioController,
              label: 'Bio',
              hint: 'Ceritakan tentang diri Anda',
              prefixIcon: Iconsax.document_text,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
