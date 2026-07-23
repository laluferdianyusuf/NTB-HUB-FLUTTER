import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/extensions/context_extensions.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.style,
    this.inputFormatters,
    this.maxLength,
    this.counterText,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final TextAlign textAlign;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? counterText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.adaptiveTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          textAlign: widget.textAlign,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          style: widget.style ?? context.inputTextStyle,
          decoration: context.appInputDecoration(
            hintText: widget.hint,
            counterText: widget.counterText,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon, size: 20) : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Iconsax.eye_slash : Iconsax.eye,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
