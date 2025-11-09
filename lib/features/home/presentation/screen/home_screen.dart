import 'package:flutter/material.dart';
import '../widget/app_bar_home.dart';
import '../widget/search_flight_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [AppBarHome(), SearchFlightForm()]),
    );
  }
}
