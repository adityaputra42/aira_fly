import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/app/theme/app_color.dart';
import 'package:pss_app/app/theme/app_font.dart';
import 'package:pss_app/core/animation/animations.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/entities/airport_entity.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';

import '../../../../../app/init_dependencies.dart';
import '../../../../../core/utils/widget_helper.dart';
part '../widget/card_search_airport.dart';

class SearchAirportArguments {
  final int? excludeAirportId;

  const SearchAirportArguments({this.excludeAirportId});
}

class SearchAirportScreen extends StatefulWidget {
  const SearchAirportScreen({super.key, this.arguments});

  final SearchAirportArguments? arguments;

  @override
  State<SearchAirportScreen> createState() => _SearchAirportScreenState();
}

class _SearchAirportScreenState extends State<SearchAirportScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  late final FlightBloc _flightBloc;

  @override
  void initState() {
    super.initState();
    _flightBloc = serviceLocator<FlightBloc>()..add(const LoadAirportsRequested(limit: 100));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AirportEntity> _filter(List<AirportEntity> airports) {
    final excludeId = widget.arguments?.excludeAirportId;
    final keyword = _query.trim().toLowerCase();

    return airports.where((airport) {
      if (excludeId != null && airport.id == excludeId) return false;
      if (keyword.isEmpty) return true;

      return (airport.code?.toLowerCase().contains(keyword) ?? false) ||
          (airport.name?.toLowerCase().contains(keyword) ?? false) ||
          (airport.city?.toLowerCase().contains(keyword) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _flightBloc,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          context: context,
          onTap: () => context.pop(),
          title: 'Select Airport',
          height: 96,
          titleColor: AppColor.darkText1,
          color: AppColor.primaryColor,
          bottomWidet: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: InputText(
              controller: _searchController,
              prefixIcon: const Icon(Icons.search, size: 16),
              hintText: "Search city, airport, or code",
              filledColor: Theme.of(context).cardColor,
              onChange: (value) => setState(() => _query = value),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<FlightBloc, FlightState>(
            builder: (context, state) {
              if (state is FlightError) {
                return Empty(title: state.message);
              }

              if (state is! AirportsLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: 10,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CardGeneral(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ShimmerLoading(width: 42, height: 42, radius: 4),

                          widget.width(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerLoading(height: 20, radius: 4, width: context.w(0.3)),
                                widget.height(4),
                                ShimmerLoading(height: 14, width: context.w(0.6), radius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final airports = _filter(state.airports);

              if (airports.isEmpty) {
                return const Empty(title: "No airports match your search");
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: airports.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 16 : 0),
                  child: StaggerItem(
                    index: index,
                    child: CardSearchAirport(airport: airports[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
