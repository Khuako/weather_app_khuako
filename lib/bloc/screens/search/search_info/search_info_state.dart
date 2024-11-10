part of 'search_info_bloc.dart';

@immutable
abstract class SearchInfoState {}

class SearchInfoInitial extends SearchInfoState {}

class SearchInfoFetched extends SearchInfoState {
  final List<AutocompleteModel> autocompleteList;

  SearchInfoFetched({required this.autocompleteList});
}

class SearchInfoLoading extends SearchInfoState {}

class SearchInfoError extends SearchInfoState {}


