import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/presentation/bloc/seatClass/seat_class_bloc.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';
import 'package:pss_app/features/home/presentation/widget/header_home.dart';
import 'package:pss_app/features/notifications/presentations/bloc/notification_bloc.dart';

import '../../../../app/init_dependencies.dart';
import '../../../../core/animation/stagger_in.dart';
import '../widget/app_bar_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<NotificationBloc>()..add(NotificationUnreadCountRequested())),
        BlocProvider.value(value: serviceLocator<FlightBloc>()),
        BlocProvider.value(
          value: serviceLocator<SeatClassBloc>()..add(LoadSeatClassesRequested(limit: 10)),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: CustomScrollView(slivers: [AppBarHome(), HeaderHome(), TipsFlight()]),
        ),
      ),
    );
  }
}

class TipsFlight extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dataTips = [
      {
        "image": AppImages.image1,
        "title": "Search",
        "subtitle": "Compare fares across every fare class for your route and date.",
      },
      {
        "image": AppImages.image2,
        "title": "Pick your seat",
        "subtitle": "See the real aircraft layout and choose where you sit.",
      },
      {
        "image": AppImages.image3,
        "title": "Pay",
        "subtitle": "Settle up by virtual account or QRIS -- no account required.",
      },
      {
        "image": AppImages.image4,
        "title": "Get your e-ticket",
        "subtitle": "Your booking code and itinerary, ready right after payment.",
      },
    ];
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tips for your flight",
                  style: AppFont.medium14.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          ),
          height(8),

          SizedBox(
            height: 140,
            child: ListView.builder(
              itemCount: dataTips.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => StaggerItem(
                index: index,
                child: CardGeneral(
                  radius: 8,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 16 : 0,
                    right: index == 3 ? 16 : 8,
                    top: 1,
                    bottom: 1,
                  ),
                  width: context.w(0.55),
                  padding: EdgeInsets.zero,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child: Image.asset(
                          width: double.infinity,
                          dataTips[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.bgDark.withValues(alpha: 0),
                              AppColor.bgDark.withValues(alpha: 0.1),
                              AppColor.bgDark.withValues(alpha: 0.25),
                              AppColor.bgDark.withValues(alpha: 0.75),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.bgDark.withValues(alpha: 0.15),
                                AppColor.bgDark.withValues(alpha: 0.25),
                                AppColor.bgDark.withValues(alpha: 0.75),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(2),
                              bottom: Radius.circular(4),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataTips[index]['title'],
                                style: AppFont.medium12.copyWith(color: AppColor.darkText1),
                              ),
                              Text(
                                dataTips[index]['subtitle'],
                                style: AppFont.reguler10.copyWith(color: AppColor.darkText1),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          height(90),
        ],
      ),
    );
  }
}
