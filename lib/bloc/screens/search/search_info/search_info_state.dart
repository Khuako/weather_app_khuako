part of 'search_info_bloc.dart';

@immutable
abstract class SearchInfoState {}

class SearchInfoInitial extends SearchInfoState {}

class SearchInfoFetched extends SearchInfoState {
  final AutocompleteModel autocompleteModel;

  SearchInfoFetched({required this.autocompleteModel});
}

class SearchInfoLoading extends SearchInfoState {}

class SearchInfoError extends SearchInfoState {}


