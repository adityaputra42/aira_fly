import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pss_app/config/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import '../widget/app_bar_home.dart';
import '../widget/search_flight_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarHome(),
          SearchFlightForm(),
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
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          width(4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height(8),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => CardGeneral(
                      padding: EdgeInsets.zero,
                      radius: 12,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 0,
                        right: 16,
                        top: 1,
                        bottom: 1,
                      ),
                      width: context.w(0.6),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 100),
                          imageUrl:
                              'https://news.atlasbeachfest.com/wp-content/uploads/2023/05/18-Gambar-Utama.webp',
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                height(140),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
