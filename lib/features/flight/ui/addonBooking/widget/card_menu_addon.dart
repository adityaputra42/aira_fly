part of '../screen/addon_booking_screen.dart';

class CardMenuAddon extends StatelessWidget {
  const CardMenuAddon({
    super.key,
    this.isSelected = false,
    required this.title,
    required this.description,
    required this.icon,
  });
  final bool isSelected;
  final String title;
  final String description;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.secondaryColor.withValues(alpha: 0.15),
            ),
            child: Center(child: Iconify(icon, size: 24, color: AppColor.secondaryColor)),
          ),
          width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFont.semibold14),
                height(2),
                Text(
                  description,
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          width(8),
          Visibility(
            visible: isSelected,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.check_circle_outline_rounded, color: AppColor.greenColor, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
