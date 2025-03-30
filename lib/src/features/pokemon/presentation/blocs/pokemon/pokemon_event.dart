part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

// EVENT TO LOAD DATA
class LoadPokemonData extends PokemonEvent {
  final int page;
  final bool fromSearch;
  const LoadPokemonData({this.page = 0, this.fromSearch = false});
}

// EVENT TO FILTER DATA
class SearchPokemon extends PokemonEvent {
  final String query;
  const SearchPokemon(this.query);
}
