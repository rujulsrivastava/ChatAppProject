import 'package:flutter/material.dart';

Widget customTextField(label, hintText, controllerText) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        TextField(
            controller: controllerText,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.black38),
              filled: true,
              fillColor: Colors.black12,
              isDense: true,
              // Added this
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              border: InputBorder.none,
            )),
      ]);
}