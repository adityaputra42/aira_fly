import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/config/routes/route_names.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_font.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/common/widget/input_text.dart';
import '../../../../core/common/widget/primary_button.dart';
import '../../../../core/constants/images.dart';

class SearchFlightForm extends StatefulWidget {
  const SearchFlightForm({super.key});

  @override
  State<SearchFlightForm> createState() => _SearchFlightFormState();
}

class _SearchFlightFormState extends State<SearchFlightForm> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            width: context.w(1),
            height: context.w(0.75),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  AppImages.map,
                  width: context.w(1),
                  color: AppColor.cardLight.withValues(alpha: .5),
                ),
              ),
            ),
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.height(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Securely Book \nYour Flight Ticket",
                    style: AppFont.semibold24.copyWith(
                      color: AppColor.darkText1,
                    ),
                  ),
                ),
                widget.height(16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 42,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).cardColor,
                  ),
                  child: TabBar(
                    physics: const NeverScrollableScrollPhysics(),
                    automaticIndicatorColorAdjustment: false,
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    isScrollable: false,
                    dividerColor: Colors.transparent,
                    indicatorColor: Theme.of(context).colorScheme.surface,
                    labelColor: AppColor.darkText1,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: AppFont.medium14,
                    unselectedLabelColor: Theme.of(context).hintColor,
                    unselectedLabelStyle: AppFont.reguler14,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index) {},
                    tabs: const [
                      Tab(child: Text("One Way")),
                      Tab(child: Text("Round Trip")),
                    ],
                  ),
                ),
                SizedBox(
                  height: 434,
                  child: TabBarView(
                    children: [
                      CardGeneral(
                        radius: 16,
                        child: Column(
                          children: [
                            InputText(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.width(12),
                                  Iconify(
                                    Mdi.airplane,
                                    size: 18,

                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              ontaped: () {
                                context.pushNamed(RouteNames.searchAirport);
                              },
                              hintText: "From",
                              title: "From",

                              readOnly: true,
                              cursor: false,
                            ),
                            widget.height(12),
                            InputText(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.width(12),
                                  Iconify(
                                    Mdi.airplane,
                                    size: 18,

                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              hintText: "To",
                              title: "To",
                              ontaped: () {
                                context.pushNamed(RouteNames.searchAirport);
                              },
                              readOnly: true,
                              cursor: false,
                            ),
                            widget.height(12),
                            InputText(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.width(12),
                                  Iconify(
                                    Mdi.calendar_day_outline,
                                    size: 18,

                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              title: "Departure Date",
                              hintText: "Departure Date",
                              readOnly: true,
                              cursor: false,
                            ),
                            widget.height(12),
                            Row(
                              children: [
                                Expanded(
                                  child: InputText(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.width(12),
                                        Iconify(
                                          Mdi.people,
                                          size: 18,
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: "Passangger",
                                    hintText: "Passangger",
                                    readOnly: true,
                                    cursor: false,
                                  ),
                                ),
                                widget.width(8),
                                Expanded(
                                  child: InputText(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.width(12),
                                        Iconify(
                                          Mdi.car_seat,
                                          size: 18,
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    hintText: "Class",
                                    title: "Class",
                                    readOnly: true,
                                    cursor: false,
                                  ),
                                ),
                              ],
                            ),
                            widget.height(24),
                            PrimaryButton(
                              title: "Search Flight",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      CardGeneral(
                        radius: 16,
                        child: Column(
                          children: [
                            InputText(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.width(12),
                                  Iconify(
                                    Mdi.airplane,
                                    size: 18,

                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              hintText: "From",
                              title: "From",
                              ontaped: () {
                                context.pushNamed(RouteNames.searchAirport);
                              },
                              readOnly: true,
                              cursor: false,
                            ),
                            widget.height(12),
                            InputText(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.width(12),
                                  Iconify(
                                    Mdi.airplane,
                                    size: 18,

                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              hintText: "To",
                              title: "To",
                              ontaped: () {
                                context.pushNamed(RouteNames.searchAirport);
                              },
                              readOnly: true,
                              cursor: false,
                            ),
                            widget.height(12),
                            Row(
                              children: [
                                Expanded(
                                  child: InputText(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.width(12),
                                        Iconify(
                                          Mdi.calendar_day_outline,
                                          size: 18,

                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: "Departure Date",
                                    hintText: "Departure Date",
                                    readOnly: true,
                                    cursor: false,
                                  ),
                                ),
                                widget.width(8),
                                Expanded(
                                  child: InputText(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.width(12),
                                        Iconify(
                                          Mdi.calendar_day_outline,
                                          size: 18,
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: "Return Date",
                                    hintText: "Return Date",
                                    readOnly: true,
                                    cursor: false,
                                  ),
                                ),
                              ],
                            ),
                            widget.height(12),
                            Row(
                              children: [
                                Expanded(
                                  child: InputText(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.width(12),
                                        Iconify(
                                          Mdi.people,
                                          size: 18,
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: "Passangger",
                                    hintText: "Passangger",
                                    readOnly: true,
                                    cursor: false,
                                  ),
                                ),
                                widget.width(8),
                                Expanded(
                                  child: InputText(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.width(12),
                                        Iconify(
                                          Mdi.car_seat,
                                          size: 18,
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    hintText: "Class",
                                    title: "Class",
                                    readOnly: true,
                                    cursor: false,
                                  ),
                                ),
                              ],
                            ),
                            widget.height(24),
                            PrimaryButton(
                              title: "Search Flight",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
