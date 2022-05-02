// Описание кода:
// 1
// Установим вес записи, кратный 10, чтобы при создании записей,
// была возможность их вставки между другими записями.
// 2
// Перемешаем список, чтобы убедиться в работоспособности сортировки.
// 3
// Чтобы не модифицировать базу записей, создадим её копию.
// 4
// Если есть необходимость, выполняем сортировку списка. В реальном проекте
// вместо вызова функции sortedList.sort должно происходить преобразование
// объекта ExampleRecordQuery в формат, принимаемый источником данных, будь
// то SQL ORDER BY или параметр GET-запроса.
// 5
// Если есть необходимость, фильтруем список, чтобы вернуть только те записи,
// которые удовлетворяют запросу. В реальном проекте вместо вызова функции
// query.suits должно происходить преобразование объекта ExampleRecordQuery
// в формат, принимаемый источником данных, будь то SQL WHERE-условие
// или HTTP GET-запрос.

// Раскомментировать строку можно для проверки того, как реагирует интерфейс
// программы, если возникла ошибка на стадии получения данных. В этом случае,
// когда мы пролистаем список до записи с весом 400, должно появиться сообщение
// об ошибке с кнопкой повторения получения результатов.


import 'dart:math';
import 'package:english_words/english_words.dart';
import 'models.dart';

const kRecordsToGenerate = 100;
const kBatchSize = 15;

class MockRepository {
  final List<ExampleRecord> _store = List<ExampleRecord>.generate(
      kRecordsToGenerate,
          (i) => ExampleRecord(
        weight: i * 10, // + 1
        title: nouns[Random().nextInt(nouns.length)],
      ))
    ..shuffle(); // + 2

  static final MockRepository _instance = MockRepository._internal();
  factory MockRepository() => _instance;
  MockRepository._internal() : super();

  Future<List<ExampleRecord>> queryRecords(ExampleRecordQuery? query) async { // *
    await Future.delayed(const Duration(seconds: 2));

    final sortedList = List.of(_store); // + 3
    if (query != null) sortedList.sort(query.compareRecords);  // + 4

    //return sortedList.where((record) => query == null || query.suits(record)).toList();  // * 5
    // if ((query?.weightGt ?? 0) > 400) throw "Test Exception"; // +6
    return sortedList.where((record) => query == null || query.suits(record)).take(kBatchSize).toList();
  }
}