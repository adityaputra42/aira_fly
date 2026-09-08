import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/flight/domain/entities/ancillary_entity.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/custom_tab_bar_pax.dart';
import 'package:pss_app/features/flight/presentation/bloc/ancillary/ancillary_bloc.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

import '../../../../../../app/init_dependencies.dart';

class AncillaryPickerScreen extends StatefulWidget {
  const AncillaryPickerScreen({super.key, required this.arguments});

  final AncillaryPickerArguments arguments;

  @override
  State<AncillaryPickerScreen> createState() => _AncillaryPickerScreenState();
}

class _AncillaryPickerScreenState extends State<AncillaryPickerScreen> {
  late final AncillaryBloc _ancillaryBloc;

  int _selectedPassengerIndex = 0;

  late Map<int, AncillaryItemEntity> _selectionByPassenger;

  List<AncillaryCategoryEntity>? _categories;

  @override
  void initState() {
    super.initState();
    _selectionByPassenger = {
      for (final s in widget.arguments.currentSelections) s.passengerIndex: s.item,
    };
    _ancillaryBloc = serviceLocator<AncillaryBloc>();
    _loadCategoriesThenCatalog();
  }

  Future<void> _loadCategoriesThenCatalog() async {
    _ancillaryBloc.add(const LoadAncillaryCategoriesRequested(limit: 50));

    final categoriesResult = await _ancillaryBloc.stream.firstWhere(
      (s) => s is AncillaryCategoriesLoaded || s is AncillaryError,
    );

    if (categoriesResult is AncillaryCategoriesLoaded) {
      _categories = categoriesResult.categories;
    }

    if (!mounted) return;
    _ancillaryBloc.add(LoadAncillariesByFlightRequested(flightId: widget.arguments.leg.flightId));
  }

  String get _unitLabel => widget.arguments.kind == AncillaryKind.baggage ? "Baggage" : "Meal";

  List<AncillaryItemEntity> _filterByKind(List<AncillaryItemEntity> items) {
    final categories = _categories;
    if (categories == null || categories.isEmpty) return items;

    final keyword = widget.arguments.kind == AncillaryKind.baggage ? 'baggage' : 'meal';
    final matchingCategoryIds = categories
        .where((c) => (c.name ?? c.code ?? '').toLowerCase().contains(keyword))
        .map((c) => c.id)
        .whereType<int>()
        .toSet();

    if (matchingCategoryIds.isEmpty) return items;

    final filtered = items.where((i) => matchingCategoryIds.contains(i.categoryId)).toList();
    return filtered.isEmpty ? items : filtered;
  }

  void _selectItem(AncillaryItemEntity item) {
    setState(() => _selectionByPassenger[_selectedPassengerIndex] = item);
  }

  void _onDone() {
    final results = _selectionByPassenger.entries
        .map(
          (entry) => SelectedAncillary(
            item: entry.value,
            flightId: widget.arguments.leg.flightId,
            passengerIndex: entry.key,
          ),
        )
        .toList();
    context.pop(results);
  }

  String _passengerLabel(int index) {
    final p = widget.arguments.passengers[index];
    final parts = [if (p.title != null) p.title, p.firstName, if (p.lastName != null) p.lastName];
    return parts.whereType<String>().join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final passengerLabels = List.generate(
      widget.arguments.passengers.length,
      (i) => _passengerLabel(i),
    );

    final segments = widget.arguments.leg.itinerary.segments ?? const [];
    final routeLabel = segments.isEmpty
        ? widget.arguments.leg.label
        : "${widget.arguments.leg.label} \u2022 ${segments.first.departureAirportCode ?? '-'} "
              "\u2192 ${segments.last.arrivalAirportCode ?? '-'}";

    final currentItem = _selectionByPassenger[_selectedPassengerIndex];

    return BlocProvider.value(
      value: _ancillaryBloc,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          context: context,
          title: "Selecting $_unitLabel",
          color: AppColor.primaryColor,
          titleColor: AppColor.darkText1,
        ),
        body: Column(
          children: [
            widget.height(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  routeLabel,
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            ),
            widget.height(12),
            DefaultTabController(
              length: passengerLabels.isEmpty ? 1 : passengerLabels.length,
              child: CustomTabBarPassager(
                titles: passengerLabels.isEmpty ? const ["-"] : passengerLabels,
                selectedIndex: _selectedPassengerIndex,
                value: currentItem?.name,
                price: currentItem != null ? double.tryParse(currentItem.currentPrice ?? '') : null,
                onTap: (index) => setState(() => _selectedPassengerIndex = index),
              ),
            ),
            widget.height(12),
            Expanded(
              child: BlocBuilder<AncillaryBloc, AncillaryState>(
                builder: (context, state) {
                  if (state is AncillaryError) {
                    return Empty(
                      title: state.message,
                      actionLabel: "Retry",
                      onAction: () => _ancillaryBloc.add(
                        LoadAncillariesByFlightRequested(flightId: widget.arguments.leg.flightId),
                      ),
                    );
                  }

                  if (state is! AncillaryFlightCatalogLoaded) {
                    return CardGeneral(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.35,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) => ShimmerLoading(radius: 6),
                      ),
                    );
                  }

                  final items = _filterByKind(state.items);

                  if (items.isEmpty) {
                    return Empty(title: "No $_unitLabel options available for this flight.");
                  }

                  return CardGeneral(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(12),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.35,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = currentItem?.id != null && currentItem!.id == item.id;
                        final price = double.tryParse(item.currentPrice ?? '');

                        return InkWell(
                          onTap: () => _selectItem(item),
                          child: CardGeneral(
                            background: isSelected
                                ? AppColor.secondaryColor.withValues(alpha: 0.08)
                                : Theme.of(context).colorScheme.surface,
                            margin: EdgeInsets.zero,
                            useShadow: false,
                            border: Border.all(
                              width: 1,
                              color: isSelected
                                  ? AppColor.primaryColor
                                  : Theme.of(context).canvasColor,
                            ),
                            padding: EdgeInsets.all(4),
                            radius: 6,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.name ?? '-',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFont.medium12.copyWith(
                                      color: isSelected
                                          ? AppColor.primaryColor
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  widget.height(2),
                                  Text(
                                    price != null ? formatIDR(price) : 'Price unavailable',
                                    style: AppFont.reguler10.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 0.5,
                  offset: Offset(0, 0.5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Total Price", style: AppFont.reguler12),
                    Text(
                      formatIDR(
                        _selectionByPassenger.values.fold<double>(
                          0,
                          (sum, item) => sum + (double.tryParse(item.currentPrice ?? '') ?? 0),
                        ),
                      ),
                      style: AppFont.medium14,
                    ),
                  ],
                ),
                PrimaryButton(
                  title: "Add $_unitLabel",
                  onPressed: _onDone,
                  width: context.w(0.4),
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
