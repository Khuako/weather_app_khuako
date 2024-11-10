import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_assistant/bloc/screens/search/change_map/change_map_bloc.dart';
import 'package:weather_assistant/bloc/screens/search/search_info/search_info_bloc.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchInfoBloc>(context);
    final changeMapBloc = BlocProvider.of<ChangeMapBloc>(context);
    FocusNode focusNode = FocusNode();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24,64,24,8),
          child: TextField(
            focusNode: focusNode,
            controller: TextEditingController(text: searchBloc.text),
            cursorColor: Colors.white,
            onChanged: (text) {
              searchBloc.add(TextControllerEvent(text: text));
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(79, 79, 79, 1.0),
              hintText: "Введите название города",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32),
                  ),
                  borderSide: BorderSide.none),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
                              padding: const EdgeInsets.only(bottom: 4),
                              child: GestureDetector(
                                  onTap: () {
                                    searchBloc.mapPoint = LatLng(
                                        double.parse(state
                                            .autocompleteList[index].latitude
                                            .toString()),
                                        double.parse(state
                                            .autocompleteList[index].longitude
                                            .toString()));
                                    changeMapBloc.add(ChangeMapEvent(
                                        mapCenter: searchBloc.mapPoint));
                                    setState(() {
                                      searchBloc.text = "";
                                      focusNode.unfocus();
                                    });
                                  },
                                  child: double.parse(state
                                              .autocompleteList[index].latitude
                                              .toString()) >
                                          0
                                      ? Text(
                                          "${state.autocompleteList[index].country}, ${state.autocompleteList[index].city}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                      : const SizedBox()),
                            );
                          },
                          itemCount: state.autocompleteList.length - 1,
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
}
