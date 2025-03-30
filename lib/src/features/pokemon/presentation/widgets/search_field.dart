import 'package:flutter/material.dart';

// WIDGET TO START FILTER DATA TO SEARCH A SPECIFIC POKEMON
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.onPressed,
    required this.onSubmitted,
    required this.controller,
  });
  final void Function()? onPressed;
  final void Function(String)? onSubmitted;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Buscar Pokémon...',
          suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: onPressed),
          border: InputBorder.none,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
