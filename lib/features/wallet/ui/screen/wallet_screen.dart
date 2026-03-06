import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/secondary_button.dart';
import 'package:pss_app/core/theme/theme.dart';
import 'package:pss_app/core/utils/widget_helper.dart';

import '../../../../core/constants/images.dart';
import '../../../../core/utils/size_extension.dart';

part '../widget/card_balance.dart';
part '../widget/card_transaction_history.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(context: context, title: "Wallet", isCanBack: false),
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
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: CardTransactionHistory(),
                            );
                          },
                          itemCount: 10,
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
    );
  }
}
