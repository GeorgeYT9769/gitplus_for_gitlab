import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final bool? selected;
  final IconData icon;
  final Function onTap;

  const DrawerListTile({
    super.key,
    required this.title,
    this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardListItem(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        tileColor: (selected ?? false)
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        selected: selected ?? false,
        leading: Icon(icon),
        title: Text(title, style: const TextStyle()),
        onTap: () => onTap(),
      ),
    );
  }
}
