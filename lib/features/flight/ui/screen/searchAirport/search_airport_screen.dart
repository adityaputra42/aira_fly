import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/core/theme/app_color.dart';
import 'package:pss_app/core/theme/app_font.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../../../core/utils/widget_helper.dart';

class SearchAirportScreen extends StatelessWidget {
  const SearchAirportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        onTap: () {
          context.pop();
        },
        title: 'Select Airport',
        height: 96,
        titleColor: AppColor.darkText1,
        color: AppColor.primaryColor,
        bottomWidet: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: InputText(
            prefixIcon: Icon(Icons.search, size: 16),
            hintText: "Search",
            filledColor: Theme.of(context).cardColor,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) => CardGeneral(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 12, top: index == 0 ? 16 : 0),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.secondaryColor.withValues(alpha: 0.1),
                  ),
                  child: Center(child: Iconify(Mdi.plane, color: AppColor.secondaryColor)),
                ),
                width(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Jakarta", style: AppFont.medium14),
                          width(8),
                          Text(
                            "(CGK)",
                            style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                      height(4),
                      Text(
                        "Soekarno Hatta",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          itemCount: 20,
        ),
      ),
    );
  }
}
