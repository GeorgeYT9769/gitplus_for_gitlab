import 'package:flutter/material.dart';

/// A card-style wrapper for list items, replacing the flat ListTile + Divider pattern.
///
/// Usage: Replace `Column(children: [ListTile(...), const Divider()])` with
/// `CardListItem(child: ListTile(...))`.
class CardListItem extends StatelessWidget {
  const CardListItem({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}
