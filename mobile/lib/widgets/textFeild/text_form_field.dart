import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class RimpaTextFormField extends StatefulWidget {
  final bool isPassword;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const RimpaTextFormField({
    super.key,
    this.isPassword = false,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.validator,
    this.onSaved,
  });

  @override
  State<RimpaTextFormField> createState() => _RimpaTextFormFieldState();
}

class _RimpaTextFormFieldState extends State<RimpaTextFormField> {
  bool _obscureText = true; // เปลี่ยนจาก RxBool เป็น bool ปกติ

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 72,
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onSaved: widget.onSaved,
        obscureText: widget.isPassword ? _obscureText : false,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: AppTextSize.md,
              fontWeight: FontWeight.w600,
            ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.secondary, fontSize: AppTextSize.md),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.secondary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.background_main, width: 1),
          ),
          // ไอคอน Toggle แสดง/ซ่อนรหัสผ่าน
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppTextColors.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
