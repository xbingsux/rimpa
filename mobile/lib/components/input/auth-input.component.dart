import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AuthInputDecoration {
  static InputDecoration getDecorationHint(String hintText) {
    return InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg),
          hintText: hintText,
          hintStyle: const TextStyle(
              color: AppTextColors.secondary,
              fontSize: AppTextSize.md),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: AppColors.background_main, width: 1)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: AppColors.primary, width: 1)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: AppColors.background_main,
                  width: 1)
          )
      );
  }

  static InputDecoration getDecorationLabel(String label) {
    return InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg),
          label: Text(
            label, 
            style: const TextStyle(
              color: AppTextColors.secondary,
              fontSize: AppTextSize.md
              ),
            ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: AppColors.background_main, width: 1)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: AppColors.primary, width: 1)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: AppColors.background_main,
                  width: 1)
          )
      );
  }
}

// import 'package:flutter/material.dart';
// import 'package:rimpa/core/constant/app.constant.dart';

// class AuthInputComponent extends StatelessWidget {
//   final Function onchange;
//   final String hintText;
//   final bool validateCheck;
//   const AuthInputComponent({super.key, required this.onchange, required this.hintText, required this.validateCheck});
  

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: (value) => onchange(value),
//       style: const TextStyle(
//           color: AppTextColors.secondary,
//           fontSize: AppTextSize.md),
//       decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(
//               horizontal: AppSpacing.lg),
//           hintText: hintText,
//           hintStyle: const TextStyle(
//               color: AppTextColors.secondary,
//               fontSize: AppTextSize.md),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: BorderSide(
//                   color: validateCheck == true ? AppColors.background_main : AppColors.danger, width: 1)),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: const BorderSide(
//                   color: AppColors.primary, width: 1)),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: const BorderSide(
//                   color: AppColors.background_main,
//                   width: 1))),
//     );
//   }
// }