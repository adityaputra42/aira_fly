import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/date_slider.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/utils/clipper.dart';
import 'package:pss_app/core/utils/dashed_divider.dart';

import '../../../../../core/common/widget/shimmer_loading.dart';
import '../../../../../core/constants/images.dart';
import '../../../../../app/routes/route_names.dart';
import '../../../../../core/utils/size_extension.dart';
part '../widget/flexible_appbar_widget.dart';
part '../widget/card_flight_selecting.dart';

class FlightSelectingScreen extends StatefulWidget {
  const FlightSelectingScreen({super.key});

  @override
  State<FlightSelectingScreen> createState() => _FlightSelectingScreenState();
}

class _FlightSelectingScreenState extends State<FlightSelectingScreen> {
  var scrollController = ScrollController();
  var isCollapsed = false;
  var expandedBarHeight = 200.0;
  var collapsedBarHeight = 60.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => _onScroll());
  }

  void _onScroll() {
    setState(() {
      isCollapsed =
          scrollController.hasClients &&
          scrollController.offset > (expandedBarHeight - collapsedBarHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: [
                // App Bar
                SliverAppBar(
                  pinned: true,
                  snap: true,
                  floating: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: isCollapsed
                        ? BorderRadius.zero
                        : BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  backgroundColor: AppColor.primaryColor,
                  collapsedHeight: collapsedBarHeight,
                  expandedHeight: expandedBarHeight,
                  automaticallyImplyLeading: false,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        AppImages.map,
                        width: context.w(1),
                        color: AppColor.cardLight.withValues(alpha: .5),
                      ),
                    ),
                    titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    expandedTitleScale: 1,
                    title: FlexibleAppBarWidget(isCollapsed: isCollapsed),
                  ),
                ),

                SliverList.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, index == 7 ? 76 : 0),
                      child: CardFlightSelecting(),
                    );
                  },
                  itemCount: 8,
                ),
              ],
            ),
            // bottom Navigation Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: CardGeneral(
                radius: 99,
                background: AppColor.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Iconify(Mdi.sort_variant, color: AppColor.secondaryColor, size: 16),
                          widget.width(8),
                          Text("Sort", style: AppFont.medium14.copyWith(color: AppColor.darkText1)),
                        ],
                      ),
                    ),
                    widget.width(24),
                    SizedBox(
                      width: 1,
                      height: 28,
                      child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
                    ),
                    widget.width(24),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Iconify(Mdi.filter_outline, color: AppColor.secondaryColor, size: 16),
                          widget.width(8),
                          Text(
                            "Filter",
                            style: AppFont.medium14.copyWith(color: AppColor.darkText1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
