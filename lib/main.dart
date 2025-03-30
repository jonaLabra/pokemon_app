import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_package_service/pokemon_package_service.dart';
import 'package:pokemon_app/src/features/pokemon/presentation/blocs/pokemon/pokemon_bloc.dart';
import 'package:pokemon_app/src/features/pokemon/presentation/screens/pokemon_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400)),
      home: BlocProvider(
        create: (context) => PokemonBloc(PokemonApiClient())..add(LoadPokemonData()),
        child: const HomeScreen(),
      ),
    );
  }
}
