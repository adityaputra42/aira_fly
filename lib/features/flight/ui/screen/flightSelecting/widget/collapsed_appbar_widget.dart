part of '../flight_selecting_screen.dart';

class CollapsedAppBarWidget extends StatelessWidget {
  const CollapsedAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: (Theme.of(context).colorScheme.onSurface).withValues(alpha: 0.1),
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 18,
              ),
            ),
          ),
        ),
        width(8),
        Expanded(
          child: Text("CGK - DPS", style: AppFont.semibold16, textAlign: TextAlign.center),
        ),
        width(8),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: (Theme.of(context).colorScheme.onSurface).withValues(alpha: 0.1),
            ),
            child: Center(
              child: Icon(
                Icons.edit_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
