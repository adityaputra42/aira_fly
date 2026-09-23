import 'package:flutter/material.dart';

import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/master/domain/entities/country_code_entity.dart';

Future<CountryCodeEntity?> showCountrySearchDialog(
  BuildContext context, {
  required List<CountryCodeEntity> countries,
  String? initialAlpha3,
}) {
  return showZoomDialog<CountryCodeEntity>(
    context: context,
    child: _CountrySearchDialog(countries: countries, initialAlpha3: initialAlpha3),
  );
}

class _CountrySearchDialog extends StatefulWidget {
  const _CountrySearchDialog({required this.countries, this.initialAlpha3});

  final List<CountryCodeEntity> countries;
  final String? initialAlpha3;

  @override
  State<_CountrySearchDialog> createState() => _CountrySearchDialogState();
}

class _CountrySearchDialogState extends State<_CountrySearchDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CountryCodeEntity> get _filtered {
    final keyword = _query.trim().toLowerCase();
    final sorted = [...widget.countries]..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    if (keyword.isEmpty) return sorted;

    return sorted.where((c) {
      return (c.name?.toLowerCase().contains(keyword) ?? false) ||
          (c.alpha2?.toLowerCase() == keyword) ||
          (c.alpha3?.toLowerCase() == keyword) ||
          (c.alpha3?.toLowerCase().contains(keyword) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.h(0.8)),
        child: CardGeneral(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Nationality", style: AppFont.medium16),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              widget.height(12),
              InputText(
                controller: _searchController,
                autoFocus: true,
                prefixIcon: const Icon(Icons.search, size: 16),
                hintText: "Search country or code",
                onChange: (value) => setState(() => _query = value),
              ),
              widget.height(12),
              Flexible(
                child: results.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Empty(title: "No country matches your search"),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: results.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                        ),
                        itemBuilder: (context, index) {
                          final country = results[index];
                          final isSelected = country.alpha3 == widget.initialAlpha3;
                          return InkWell(
                            onTap: () => Navigator.of(context).pop(country),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(country.name ?? '-', style: AppFont.reguler14),
                                  ),
                                  Text(
                                    country.alpha3 ?? '-',
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    widget.width(8),
                                    Icon(Icons.check, size: 18, color: AppColor.primaryColor),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
