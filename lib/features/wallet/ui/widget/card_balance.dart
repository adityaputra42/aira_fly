part of '../screen/wallet_screen.dart';

class CardBalance extends StatelessWidget {
  const CardBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      width: double.infinity,
      margin: EdgeInsets.zero,
      gradient: AppColor.cardGradient,
      background: AppColor.primaryColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              AppImages.map,
              width: context.w(0.6),
              color: AppColor.cardLight.withValues(alpha: .5),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(16),
              Text("Your Balance :", style: AppFont.medium14.copyWith(color: AppColor.darkText1)),
              height(4),
              Row(
                children: [
                  Text(
                    NumberFormat.currency(
                      locale: "id_ID",
                      symbol: "IDR ",
                      decimalDigits: 0,
                    ).format(11250000),
                    style: AppFont.semibold24.copyWith(color: AppColor.darkText1, fontSize: 32),
                  ),
                  width(8),
                  Icon(Icons.visibility_outlined, size: 24, color: AppColor.darkText1),
                ],
              ),
              height(16),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      borderColor: AppColor.darkText1,
                      textColor: AppColor.darkText1,
                      bgColor: AppColor.cardLight.withValues(alpha: 0.1),
                      title: "Top Up",
                      onPressed: () {},
                    ),
                  ),
                  width(8),
                  Expanded(
                    child: SecondaryButton(
                      borderColor: AppColor.darkText1,
                      textColor: AppColor.darkText1,
                      bgColor: AppColor.cardLight.withValues(alpha: 0.1),
                      title: "Transfer",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
