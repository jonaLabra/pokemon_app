import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/src/core/core.dart';
import 'package:pokemon_app/src/features/pokemon/presentation/widgets/pokemon_card.dart';
import 'package:pokemon_app/src/features/pokemon/presentation/widgets/search_field.dart';
import 'package:pokemon_package_service/pokemon_package_service.dart';

import '../blocs/pokemon/pokemon_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  int _currentPage = 1;
  int _actualItem = 0;
  bool _canSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors,
          ),
        ),
        child: BlocBuilder<PokemonBloc, PokemonState>(
          builder: (context, state) {
            return Column(
              children: [
                state is PokemonLoading
                    ? _loadingScreen()
                    : state is PokemonError
                    ? _errorScreen(message: state.message)
                    : state is PokemonLoaded
                    ? _loadedScreen(pokemons: state.pokemons)
                    : state is PokemonFilteredLoaded
                    ? _searchPokemonScreen(pokemons: state.pokemons)
                    : const Expanded(flex: 9, child: SizedBox()),
              ],
            );
          },
        ),
      ),
    );
  }

  // APP BAR
  PreferredSizeWidget _appBar() => AppBar(
    elevation: 0,
    shadowColor: Colors.transparent,
    title:
        _canSearch
            ? SearchField(
              onPressed: () {
                final query = _controller.text.trim();
                if (query.isNotEmpty) {
                  context.read<PokemonBloc>().add(SearchPokemon(query));
                }
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<PokemonBloc>().add(SearchPokemon(value));
                }
              },
              controller: _controller,
            )
            : Text('POKEDEX', style: pikachuTextStyle),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed:
            () => setState(() {
              _canSearch = !_canSearch;
              if (!_canSearch) {
                _controller.clear();
                context.read<PokemonBloc>().add(LoadPokemonData(page: 0, fromSearch: true));
              }
            }),
        icon: Icon(_canSearch ? Icons.cancel : Icons.search, color: Colors.white),
      ),
    ],
    backgroundColor: Colors.transparent,
  );

  // SHOW SCREEN WHEN STATE IS LOADING
  Widget _loadingScreen() => Expanded(
    flex: 9,
    child: Center(child: CircularProgressIndicator.adaptive(backgroundColor: Colors.yellow)),
  );

  // SHOW WHEN STATE IS ERROR
  Widget _errorScreen({required String message}) => Expanded(
    flex: 9,
    child: Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
      ),
    ),
  );

  // SHOW WHEN STATE IS LOADED
  Widget _loadedScreen({required List<Pokemon> pokemons}) => Expanded(
    flex: 9,
    child: CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        scrollDirection: Axis.vertical,
        initialPage: _actualItem,
        enableInfiniteScroll: false,
        viewportFraction: 0.5,
        onPageChanged: (index, reason) {
          setState(() {
            _actualItem = index;
          });
          if (index == pokemons.length) {
            context.read<PokemonBloc>().add(LoadPokemonData(page: _currentPage++));
          }
        },
      ),
      itemCount: pokemons.length + 1,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        if (index < pokemons.length) {
          return PokemonCard(pokemon: pokemons[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircleAvatar(
                child: CircularProgressIndicator.adaptive(backgroundColor: Colors.yellow),
              ),
            ),
          );
        }
      },
    ),
  );

  // SHOW WHEN STATE IS FILTERED DATA
  Widget _searchPokemonScreen({required List<Pokemon> pokemons}) => Expanded(
    flex: 9,
    child: CarouselSlider(
      items: pokemons.map((pokemon) => PokemonCard(pokemon: pokemon)).toList(),
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        scrollDirection: Axis.vertical,
        initialPage: _actualItem,
        enableInfiniteScroll: false,
        viewportFraction: 0.5,
      ),
    ),
  );
}
