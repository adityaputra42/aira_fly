import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/secondary_button.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:pss_app/features/wallet/presentation/bloc/wallet_bloc.dart';

import '../../../../core/constants/images.dart';
import '../../../../core/utils/size_extension.dart';

part '../widget/card_balance.dart';
part '../widget/card_transaction_history.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: serviceLocator<WalletBloc>()
            ..add(LoadBalanceRequested())
            ..add(LoadWalletTransactionsRequested()),
        ),
      ],
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          context: context,
          title: "Wallet",
          isCanBack: false,
          color: AppColor.primaryColor,
          titleColor: AppColor.darkText1,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardBalance(),
                height(12),
                Expanded(
                  child: CardGeneral(
                    margin: EdgeInsets.only(bottom: 68),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Transaction History", style: AppFont.medium16),
                        height(8),
                        Expanded(
                          child: BlocBuilder<WalletBloc, WalletState>(
                            builder: (context, state) {
                              if (state.transactionsStatus == WalletStatus.loading) {
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: CardGeneral(
                                        radius: 6,
                                        margin: EdgeInsets.zero,
                                        useShadow: false,
                                        padding: EdgeInsets.fromLTRB(6, 6, 12, 6),
                                        background: Theme.of(context).colorScheme.surface,
                                        child: Row(
                                          children: [
                                            CardGeneral(
                                              margin: EdgeInsets.zero,
                                              useShadow: false,
                                              background: AppColor.secondaryColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              padding: EdgeInsets.all(8),
                                              radius: 4,
                                              child: Iconify(
                                                Mdi.instant_deposit,
                                                size: 24,
                                                color: AppColor.secondaryColor,
                                              ),
                                            ),
                                            width(12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ShimmerLoading(
                                                    radius: 4,
                                                    width: context.w(0.35),
                                                    height: 20,
                                                  ),
                                                  height(2),
                                                  ShimmerLoading(
                                                    radius: 4,
                                                    width: context.w(0.25),
                                                    height: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ShimmerLoading(
                                              radius: 4,
                                              width: context.w(0.2),
                                              height: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: 10,
                                );
                              }
                              if (state.transactionsStatus == WalletStatus.success) {
                                if (state.transactions.isEmpty) {
                                  return Center(child: Empty(title: "No Record Found"));
                                }
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: CardTransactionHistory(
                                        data: state.transactions[index],
                                      ),
                                    );
                                  },
                                  itemCount: state.transactions.length,
                                );
                              }
                              return Center(child: Empty(title: "No Record Found"));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
