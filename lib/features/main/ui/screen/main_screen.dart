import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/features/home/presentation/screen/home_screen.dart';
import '../../cubit/main_cubit.dart';
import '../widget/custom_bottom_navbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    body(int selectedIndex) {
      switch (selectedIndex) {
        case 0:
          return HomeScreen();
        case 1:
          return const Center(child: Text("Ticket"));
        case 2:
          return const Center(child: Text("History"));
        case 3:
          return const Center(child: Text("Setting"));

        default:
          return HomeScreen();
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<MainCubit, int>(
        builder: (context, selectedIndex) {
          return Stack(
            children: [
              body(selectedIndex),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: CustomBottomNavbar(
                    onTap: (index) {
                      context.read<MainCubit>().setTab(index);
                    },
                    selectedIndex: selectedIndex,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
