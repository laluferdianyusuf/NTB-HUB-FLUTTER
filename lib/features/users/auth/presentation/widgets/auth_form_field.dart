import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';

class AuthFormField extends StatefulWidget {
  const AuthFormField({
    super.key,
    required this.name,
    required this.label,
    required this.hint,
    this.icon = Iconsax.user,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validators = const [],
  });

  final String name;
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<String? Function(String?)> validators;

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.adaptiveTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: widget.name,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          validator: FormBuilderValidators.compose(widget.validators),
          style: context.inputTextStyle,
          decoration: context.appInputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(widget.icon, size: 20),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Iconsax.eye_slash : Iconsax.eye,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
