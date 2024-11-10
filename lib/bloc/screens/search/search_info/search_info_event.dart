part of 'search_info_bloc.dart';

@immutable
abstract class SearchInfoEvent {}

class TextControllerEvent extends SearchInfoEvent{
  final String text;

  TextControllerEvent({required this.text});
}
