import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:weather_assistant/bloc/screens/search/change_map/change_map_bloc.dart';
import 'package:weather_assistant/bloc/screens/search/search_info/search_info_bloc.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onDrawerPressed,
    this.changeLocation,
    this.showMenu = false,
    this.showVoiceInput = false,
  });

  final VoidCallback? onDrawerPressed;
  final Function(LatLng loc)? changeLocation;
  final bool showMenu;
  final bool showVoiceInput;
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _voiceInput = "";

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchInfoBloc>(context);
    final changeMapBloc = BlocProvider.of<ChangeMapBloc>(context);
    FocusNode focusNode = FocusNode();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 8),
          child: Row(
            children: [
              if (widget.showMenu)
                IconButton(
                  onPressed: widget.onDrawerPressed,
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: TextEditingController(text: searchBloc.text),
                  cursorColor: Colors.white,
                  onChanged: (text) {
                    if (text.length > 3) {
                      searchBloc.add(TextControllerEvent(text: text));
                    }
                  },
                  onEditingComplete: () {
                    searchBloc.add(TextControllerEvent(text: searchBloc.text));
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(79, 79, 79, 1.0),
                    hintText: "Введите название города",
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (widget.showVoiceInput)
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.black54,
                  ),
                  onPressed: _toggleListening,
                ),
            ],
          ),
        ),
        BlocBuilder<SearchInfoBloc, SearchInfoState>(
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(8.0),
              height: searchBloc.text.isNotEmpty ? 150 : 0,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(79, 79, 79, 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(32),
                ),
              ),
              child: state is SearchInfoLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : state is SearchInfoFetched
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  searchBloc.mapPoint = LatLng(
                                    state.autocompleteModel.results?[index].latitude ?? 0,
                                    state.autocompleteModel.results?[index].longitude ?? 0,
                                  );
                                  changeMapBloc.add(ChangeMapEvent(mapCenter: searchBloc.mapPoint));
                                  setState(() {
                                    searchBloc.text = "";
                                    focusNode.unfocus();
                                  });
                                  widget.changeLocation?.call(LatLng(
                                    state.autocompleteModel.results?[index].latitude ?? 0,
                                    state.autocompleteModel.results?[index].longitude ?? 0,
                                  ));
                                },
                                child: Text(
                                  "${state.autocompleteModel.results?[index].country}, "
                                  "${state.autocompleteModel.results?[index].admin1}, "
                                  "${state.autocompleteModel.results?[index].name}",
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            );
                          },
                          itemCount: (state.autocompleteModel.results?.length ?? 1) - 1,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16),
                        )
                      : const Center(
                          child: Text(
                            "Неизвестная ошибка",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
            );
          },
        )
      ],
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    } else {
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == "listening"),
        onError: (val) => print("Error: $val"),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _voiceInput = val.recognizedWords;
              BlocProvider.of<SearchInfoBloc>(context).add(TextControllerEvent(text: _voiceInput));
            });
          },
        );
      }
    }
  }
}
