import 'package:flutter/material.dart';

import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_font.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key, this.selectedIndex, this.onTap});
  final int? selectedIndex;
  final Function(int index)? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 24),
      width: context.w(0.88),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          navbarItem(
            context,
            title: "Home",
            icon: Mdi.home_outline,
            isSelected: selectedIndex == 0,
            index: 0,
          ),
          navbarItem(
            context,
            title: "Ticket",
            icon: Ph.ticket,
            isSelected: selectedIndex == 1,
            index: 1,
          ),
          navbarItem(
            context,
            title: "history",
            icon: Mdi.list_box_outline,
            isSelected: selectedIndex == 2,
            index: 2,
          ),
          navbarItem(
            context,
            title: "Setting",
            icon: Uil.setting,
            isSelected: selectedIndex == 3,
            index: 3,
          ),
        ],
      ),
    );
  }

  InkWell navbarItem(
    BuildContext context, {
    required int index,
    required bool isSelected,
    required String icon,
    String? title,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: AnimatedSize(
        alignment: isSelected ? Alignment.centerLeft : Alignment.center,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: isSelected
            ? activeNavbar(context, icon: icon, title: title ?? "")
            : inactiveNavbar(context, icon: icon),
      ),
    );
  }

  Widget activeNavbar(
    BuildContext context, {
    required String icon,
    required String title,
  }) {
    return Container(
      height: 44,
      width: context.w(0.275),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: AppColor.primaryColor),
              color: AppColor.darkText1,
            ),
            child: Iconify(icon, size: 20, color: AppColor.primaryColor),
          ),
          width(4),
          Flexible(
            child: Text(
              title,
              style: AppFont.medium12.copyWith(color: AppColor.darkText1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width(4),
        ],
      ),
    );
  }

  Widget inactiveNavbar(BuildContext context, {required String icon}) {
    return Container(
      height: 44,
      width: 44,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Iconify(icon, size: 20, color: AppColor.grayColor),
    );
  }
}
