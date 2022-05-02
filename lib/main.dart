// https://github.com/astoniocom/fl_list_example/

// Описание кода:
// 1
// Виджет создаёт экземпляр класса ListController и предоставляет доступ к нему
// в других виджетах, которые находятся ниже по иерархии.
// 2
// Наблюдаем за изменением состояния контроллера ListController. Если его
// состояние изменилось (было установлено новое значение value и, следовательно,
// вызвана функция notifyListeners()), то произойдёт новый вызов функции build.
// Через переменную listController мы получаем доступ к этому контроллеру.
// 3
// В переменную listState помещаем актуальное состояние контроллера для
// формирования более читаемого кода далее.
// 4
// Виджет состояния списка ListStatusIndicator отображается дополнительной
// строкой в виджете списка ListView. Однако нет смысла отображать состояние
// списка постоянно. В зависимости от результата выполнения hasStatus определяем,
// нужно ли отображать виджет состояние списка и, следовательно, нужно ли
// резервировать для него дополнительную строку. Конечно, можно было бы
// отображать виджет состояния и поверх виджета ListView, но выбранный подход
// более удобен, когда мы чуть позже будем реализовывать загрузку данных списка
// частями.
// 5
// Если необходимо, отображаем виджет состояния списка в последней строке
// виджета ListView.
// 6
// Если во время загрузки списка произошла ошибка, отобразится виджет состояния
// списка с кнопкой обновления. После нажатия на эту кнопку вызовется метод
// repeatQuery контроллера, который повторит последний запрос.
// 7
// Получаем данные, необходимые для отображения соответствующей строки списка,
// и формируем эту строку.

import 'list_controller.dart'; // +
import 'widgets/list_status_indicator.dart'; // +
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // +
import 'models.dart'; // +
import 'widgets/record_teaser.dart'; // +

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // +
      home: ChangeNotifierProvider( // + 1
        create: (_) => ListController(query: const ExampleRecordQuery(contains: "ea")), // +
        child: const HomePage(), // +
      ), //+
    ); // +
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final listController = context.watch<ListController>(); // + 2
    final listState = listController.value; // + 3
    final itemCount = listState.records.length + (ListStatusIndicator.hasStatus(listState) ? 1 : 0); // + 4
    return Scaffold(
      appBar: AppBar(title: const Text("List Demo")),
      body: ListView.builder( // +
        itemBuilder: (context, index) {
          if (index == listState.records.length && ListStatusIndicator.hasStatus(listState)) { // + 5
            return ListStatusIndicator(listState, onRepeat: listController.repeatQuery); // + 6
          } // +

          final record = listState.records[index]; // + 7
          return RecordTeaser(record: record); // * //ListTile(title: Text(record.title)); // +
        }, // +
        itemCount: itemCount,
      ),
    );
  }
}