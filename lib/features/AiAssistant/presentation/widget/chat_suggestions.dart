import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';

class ChatSuggestions extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const ChatSuggestions({super.key, required this.onSelected});

  static const suggestions = [
    'Find a flight',
    'Check my booking',
    'Wallet balance',
    'Baggage policy',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            onPressed: () => onSelected(suggestions[index]),
            label: Text(suggestions[index],style: AppFont.medium12.copyWith(color: colors.primary),),
            avatar: const Icon(Icons.arrow_outward_rounded, size: 16),
            side: BorderSide(color: colors.primary),
            backgroundColor: colors.surface,
          );
        },
      ),
    );
  }
}
