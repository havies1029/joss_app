import 'package:flutter/material.dart';

class TableHeaderConfig {
  final String title;
  final bool center;
  const TableHeaderConfig(this.title, {this.center = false});
}

class TableColumnBuilder<T> {
  final Widget Function(BuildContext, T item, int index) builder;
  const TableColumnBuilder({required this.builder});
}

enum TableActionType { endorse, delete, lacak }

class TableActionConfig {
  final TableActionType type;
  final String asset;
  final Color color;

  const TableActionConfig({
    required this.type,
    required this.asset,
    required this.color,
  });
}
