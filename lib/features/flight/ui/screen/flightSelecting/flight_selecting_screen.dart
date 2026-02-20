import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/date_slider.dart';
import 'package:pss_app/core/theme/theme.dart';
import 'package:pss_app/core/utils/dashed_divider.dart';

import '../../../../../core/constants/images.dart';
import '../../../../../core/utils/size_extension.dart';
part 'widget/collapsed_appbar_widget.dart';
part 'widget/flexible_appbar_widget.dart';

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
                  title: Visibility(visible: isCollapsed, child: CollapsedAppBarWidget()),
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
                    title: Visibility(visible: !isCollapsed, child: FlexibleAppBarWidget()),
                  ),
                ),
                //
                SliverList.builder(
                  itemBuilder: (context, index) {
                    return CardGeneral(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("data"),
                    );
                  },
                  itemCount: 10,
                ),
              ],
            ),
            // bottom Navigation Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: CardGeneral(
                radius: 99,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sort),
                          widget.width(8),
                          Text("Sort", style: AppFont.medium14),
                        ],
                      ),
                    ),
                    widget.width(24),
                    SizedBox(width: 1, height: 32, child: VerticalDivider(thickness: 1)),
                    widget.width(24),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter),
                          widget.width(8),
                          Text("Filter", style: AppFont.medium14),
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
