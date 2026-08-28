import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/app/theme/theme.dart';

import '../../../../../core/utils/size_extension.dart';

class CustomTabBarPassager extends StatefulWidget {
  final int? selectedIndex;
  final List<String> titles;
  final Function(int)? onTap;
  final double fonsize;
  final String? value;
  final double? price;
  const CustomTabBarPassager({
    super.key,
    required this.titles,
    this.selectedIndex,
    this.fonsize = 14,
    this.onTap,
    this.value,
    this.price,
  });

  @override
  State<CustomTabBarPassager> createState() => _CustomTabBarPassagerState();
}

class _CustomTabBarPassagerState extends State<CustomTabBarPassager> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TabBar(
        automaticIndicatorColorAdjustment: true,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.onSurface,
        labelPadding: EdgeInsets.zero,
        labelStyle: AppFont.medium14,
        unselectedLabelColor: Theme.of(context).hintColor,
        unselectedLabelStyle: AppFont.reguler12,
        padding: EdgeInsets.zero,

        indicatorSize: TabBarIndicatorSize.label,

        onTap: (index) {
          if (widget.onTap != null) {
            widget.onTap!(index);
          }
        },

        tabs: widget.titles
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(
                  left: widget.titles.indexOf(e) == 0 ? 16 : 0,
                  right: widget.titles.indexOf(e) == (widget.titles.length - 1) ? 16 : 8,
                ),
                child: CardTabPassangger(
                  isSelected: widget.selectedIndex == widget.titles.indexOf(e),
                  passengger: e,
                  index: widget.titles.indexOf(e) + 1,
                  value: widget.value,
                  price: widget.price,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class CardTabPassangger extends StatelessWidget {
  const CardTabPassangger({
    super.key,
    required this.passengger,
    required this.index,
    this.isSelected = false,
    this.value,
    this.price,
  });
  final String passengger;
  final String? value;
  final double? price;
  final int index;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      height: value != null ? 78 : 58,
      margin: EdgeInsets.zero,
      useShadow: false,
      background: isSelected ? AppColor.primaryColor : Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      radius: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$index. $passengger',
            style: AppFont.medium14.copyWith(
              color: isSelected ? AppColor.darkText1 : Theme.of(context).hintColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Visibility(
            visible: value != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                value ?? '',
                style: AppFont.reguler12.copyWith(
                  color: isSelected ? AppColor.darkText1 : Theme.of(context).hintColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          height(4),
          Text(
            NumberFormat.currency(
              locale: "id_ID",
              symbol: "Rp ",
              decimalDigits: 0,
            ).format(price ?? 0),
            style: AppFont.reguler12.copyWith(
              color: isSelected ? AppColor.darkText1 : Theme.of(context).hintColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
