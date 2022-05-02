// Описание кода:
// 1
// Так как этот виджет будет отображаться в дополнительной строке
// списка ListView, необходимо определять, есть ли в ней необходимость и будет
// ли данный виджет что-то отображать. Это делается при помощи функции hasStatus,
// которая сообщает о целесообразности использования этого виджета.


import '../list_state.dart';
import 'package:flutter/material.dart';

class ListStatusIndicator extends StatelessWidget {
  final ListState listState;
  final Function()? onRepeat;

  const ListStatusIndicator(this.listState, {this.onRepeat, Key? key}) : super(key: key);

  static bool hasStatus(ListState listState) => listState.hasError || listState.isLoading || (listState.isInitialized && listState.records.isEmpty); // 1

  @override
  Widget build(BuildContext context) {
    Widget? stateIndicator;
    if (listState.hasError) {
      stateIndicator = const Text("Loading Error", textAlign: TextAlign.center);
      if (onRepeat != null) {
        stateIndicator = Row(
          mainAxisSize: MainAxisSize.min,
          children: [stateIndicator, const SizedBox(width: 8), IconButton(onPressed: onRepeat, icon: const Icon(Icons.refresh))],
        );
      }
    } else if (listState.isLoading) {
      stateIndicator = const CircularProgressIndicator();
    } else if (listState.isInitialized && listState.records.isEmpty) {
      stateIndicator = const Text("No results", textAlign: TextAlign.center);
    }

    if (stateIndicator == null) return Container();

    return Container(alignment: Alignment.center, child: stateIndicator);
  }
}