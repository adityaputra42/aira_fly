import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/presentation/bloc/bloc/seat_class_bloc.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';
import 'package:pss_app/features/home/presentation/widget/header_home.dart';

import '../../../../app/init_dependencies.dart';
import '../widget/app_bar_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<FlightBloc>()),
        BlocProvider.value(
          value: serviceLocator<SeatClassBloc>()..add(LoadSeatClassesRequested(limit: 10)),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              AppBarHome(),
              HeaderHome(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tips for your flight",
                            style: AppFont.medium14.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View All",
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              width(4),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    height(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: 2,
                        itemBuilder: (context, index) => CardGeneral(margin: EdgeInsets.zero),
                      ),

                      // Column(
                      //   children: List.generate(
                      //     4,
                      //     (index) => CardGeneral(margin: EdgeInsets.only(bottom: 8)),
                      //   ),
                      // ),
                    ),
                    // SizedBox(
                    //   height: 140,
                    //   child: ListView.builder(
                    //     itemCount: 10,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) => StaggerItem(
                    //       index: index,
                    //       child: CardGeneral(
                    //         padding: EdgeInsets.zero,
                    //         radius: 12,
                    //         margin: EdgeInsets.only(
                    //           left: index == 0 ? 16 : 0,
                    //           right: 16,
                    //           top: 1,
                    //           bottom: 1,
                    //         ),
                    //         width: context.w(0.6),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    height(90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
