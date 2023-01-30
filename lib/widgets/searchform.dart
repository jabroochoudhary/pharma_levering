import '/widgets/size_config.dart';
import 'package:flutter/material.dart';

class SearchField {
  filed({
    required Function onChange,
    required Function onSubmit,
  }) {
    return TextFormField(
      cursorColor: Colors.green,
      onChanged: (value) {
        onChange(value);
      },
      onFieldSubmitted: (value) {
        onSubmit(value);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        hintText: ' Search items',
        filled: true,
        fillColor: Color.fromARGB(255, 217, 246, 213),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(color: Colors.black12)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(color: Colors.black12)),
        // disabledBorder: InputBorder.none,
      ),
    );
  }
}
