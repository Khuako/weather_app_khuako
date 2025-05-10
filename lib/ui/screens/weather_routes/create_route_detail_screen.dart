import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_assistant/bloc/screens/route/create_route_cubit.dart';
import 'package:weather_assistant/ui/widgets/core/custom_loading_screen.dart';

class CreateRouteDetailScreen extends StatefulWidget {
  const CreateRouteDetailScreen({super.key});

  @override
  State<CreateRouteDetailScreen> createState() => _CreateRouteDetailScreenState();
}

class _CreateRouteDetailScreenState extends State<CreateRouteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRouteCubit, CreateRouteState>(builder: (context, state) {
      return CustomLoadingScreen();
    },);
  }
}
