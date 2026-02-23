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
part '../widget/card_search_airport.dart';

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
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(top: index == 0 ? 16 : 0),
            child: CardSearchAirport(),
          ),
          itemCount: 20,
        ),
      ),
    );
  }
}
