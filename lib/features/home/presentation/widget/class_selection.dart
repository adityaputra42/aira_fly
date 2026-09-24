import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/features/flight/domain/entities/seat_class_entity.dart';
import 'package:pss_app/features/flight/presentation/bloc/bloc/seat_class_bloc.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/common/widget/primary_button.dart';

class ClassSelection extends StatefulWidget {
  const new({super.key, this.param});

  final SeatClassEntity? param;
  @override
  State<ClassSelection> createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {
  SeatClassEntity? selectedClass;

  void selectClass(SeatClassEntity? value) {
    setState(() {
      selectedClass = value;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.param != null) {
      selectedClass = widget.param;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<SeatClassBloc>(),
      child: Dialog(
        child: BlocBuilder<SeatClassBloc, SeatClassState>(
          builder: (context, state) {
            List<SeatClassEntity> listData = [SeatClassEntity(name: "All Class", code: "ALL")];
            if (state is SeatClassLoaded) {
              listData.addAll(state.seatClasses);
            }
            return CardGeneral(
              margin: EdgeInsets.zero,
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cabin Class",
                        style: AppFont.medium16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 24,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    spacing: 12,
                    children: List.generate(listData.length, (index) {
                      var item = listData[index];
                      return InkWell(
                        onTap: () {
                          selectClass(item);
                        },
                        child: CardGeneral(
                          useShadow: false,
                          border: Border.all(
                            width: 1,
                            color: selectedClass?.code == item.code
                                ? AppColor.secondaryColor
                                : Theme.of(context).canvasColor,
                          ),
                          radius: 8,
                          background: selectedClass?.code == item.code
                              ? AppColor.secondaryColor.withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.surface,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: EdgeInsets.zero,
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(
                                selectedClass?.code == item.code
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                size: 16,
                                color: selectedClass?.code == item.code
                                    ? AppColor.secondaryColor
                                    : Theme.of(context).hintColor,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name ?? '', style: AppFont.medium12),
                                    Text(
                                      item.code ?? '',
                                      style: AppFont.reguler10.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  PrimaryButton(
                    title: "Save",
                    onPressed: () {
                      Navigator.of(context).pop(selectedClass);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
