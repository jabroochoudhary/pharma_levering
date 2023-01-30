import 'package:e_medicine_shop/appcolors/app_colors.dart';
import 'package:flutter/material.dart';

class MyTextFromField extends StatelessWidget {
  final String hintText;
  bool obscureText = false;
  TextEditingController? controller = TextEditingController();
  bool isNumber;
  int lines;
  bool readOnly;
  MyTextFromField({
    required this.hintText,
    required this.obscureText,
    this.controller,
    this.lines = 1,
    this.readOnly=false,
    this.isNumber = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: lines,
        readOnly: readOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: (InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,
          hintText: hintText,
          label: Text(
            hintText,
            style: TextStyle(color: AppColors.baseBlackColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        )),
      ),
    );
  }
}
