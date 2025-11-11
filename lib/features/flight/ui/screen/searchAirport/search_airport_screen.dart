import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pss_app/config/theme/app_color.dart';
import 'package:pss_app/config/theme/app_font.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/utils/size_extension.dart';

class SearchAirportScreen extends StatelessWidget {
  const SearchAirportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primaryColor,
        title: InkWell(
          onTap: () {
            context.pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Theme.of(context).cardColor,
              ),
              width(12),
              Text(
                "Select Airport",
                style: AppFont.medium16.copyWith(
                  color: Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            height(12),
            InputText(
              prefixIcon: Icon(Icons.search, size: 16),
              hintText: "Search",
              filledColor: Theme.of(context).cardColor,
            ),
            height(12),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => CardGeneral(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Iconify(
                        Mdi.airplane_takeoff,
                        color: AppColor.primaryColor,
                      ),
                      width(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("")],
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
