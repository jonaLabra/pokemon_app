import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokemon_package_service/pokemon_package_service.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonApiClient _service;
  static const int pageSize = 20;
  final List<Pokemon> listResponse = [];

  PokemonBloc(this._service) : super(PokemonInitial()) {
    on<LoadPokemonData>(_loadPokemonData);
    on<SearchPokemon>(_searchPokemon);
  }

  //EMMIT A LOAD PROCESS TO GET DATA
  void _loadPokemonData(LoadPokemonData event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    try {
      if (event.fromSearch) {
        emit(PokemonLoaded(listResponse, event.page));
      } else {
        final offset = event.page * pageSize;
        final pokemons = await _service.fetchPokemonData(offset: offset, limit: pageSize);
        pokemons.fold((failure) => emit(PokemonError(failure.message)), (pokemons) {
          listResponse.addAll(pokemons);
          emit(PokemonLoaded(listResponse, event.page));
        });
      }
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }

  //EMMIT A SEARCH PROCESS TO GET FILTER DATA
  void _searchPokemon(SearchPokemon event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    try {
      final allPokemons = await _service.fetchPokemonData(offset: 0, limit: 1000);
      allPokemons.fold((failure) => emit(PokemonError(failure.message)), (pokemons) {
        final filtered =
            pokemons
                .where((p) => p.name.toLowerCase().contains(event.query.toLowerCase().trim()))
                .toList();
        if (filtered.isEmpty) {
          emit(PokemonError('Pokemon no encontrado'));
        } else {
          emit(PokemonFilteredLoaded(filtered));
        }
      });
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }
}
