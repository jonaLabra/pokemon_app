part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

// INITIAL STATE
class PokemonInitial extends PokemonState {}

// LOADING STATE
class PokemonLoading extends PokemonState {}

// LOADED STATE
class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final int currentPage;
  const PokemonLoaded(this.pokemons, this.currentPage);
}

// FILTER DATA STATE
class PokemonFilteredLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  const PokemonFilteredLoaded(this.pokemons);
}

// ERROR STATE
class PokemonError extends PokemonState {
  final String message;
  const PokemonError(this.message);
}
