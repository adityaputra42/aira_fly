part of '../screen/wallet_screen.dart';

class CardBalance extends StatelessWidget {
  const CardBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      bloc: serviceLocator<WalletBloc>(),
      builder: (context, state) {
        var balanceData = BalanceEntity();
        if (state.balanceStatus == WalletStatus.success) {
          balanceData = state.balance ?? BalanceEntity();
        }
        return CardGeneral(
          width: double.infinity,
          margin: EdgeInsets.zero,
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
                  Text(
                    "Your Balance :",
                    style: AppFont.medium14.copyWith(color: AppColor.darkText1),
                  ),
                  height(4),
                  Row(
                    children: [
                      state.balanceStatus == WalletStatus.loading
                          ? ShimmerLoading(width: context.w(0.5), height: 34)
                          : Text(
                              NumberFormat.currency(
                                locale: "id_ID",
                                symbol: "${balanceData.currency ?? "IDR"} ",
                                decimalDigits: 0,
                              ).format(balanceData.balance ?? 0),
                              style: AppFont.semibold24.copyWith(
                                color: AppColor.darkText1,
                                fontSize: 32,
                              ),
                            ),
                      width(8),
                      Icon(Icons.visibility_outlined, size: 24, color: AppColor.darkText1),
                    ],
                  ),
                  height(16),
                  Row(
                    children: [
                      Expanded(
                        child: state.balanceStatus == WalletStatus.loading
                            ? ShimmerLoading(height: 40)
                            : SecondaryButton(
                                borderColor: AppColor.darkText1,
                                textColor: AppColor.darkText1,
                                bgColor: AppColor.cardLight.withValues(alpha: 0.1),
                                title: "Top Up",
                                onPressed: () {},
                              ),
                      ),
                      width(8),
                      Expanded(
                        child: state.balanceStatus == WalletStatus.loading
                            ? ShimmerLoading(height: 40)
                            : SecondaryButton(
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
      },
    );
  }
}
