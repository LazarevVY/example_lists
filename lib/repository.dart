// Описание кода:
// 1
// При создании объекта репозитория заполним private-переменную _store (условную
// базу данных) записями со случайными словами.
// 2
// Чтобы всегда работать с одним и тем же источником данных, сделаем так, чтобы
// класс репозитория был синглтоном, то есть мог иметь только один экземпляр.
// 3
// Функция, к которой будем обращаться для получения записей из базы данных.
// В реальном проекте в коде этой функции должно происходить обращение к
// «настоящей» базе данных или http-запрос.
// 4
// Строка добавляет имитацию задержки при получении данных.

import 'dart:math';
import 'package:english_words/english_words.dart';
import 'models.dart';

const kRecordsToGenerate = 100;

class MockRepository {
  // 1
  final List<ExampleRecord> _store = List<ExampleRecord>.generate(
      kRecordsToGenerate,
          (i) => ExampleRecord(
        title: nouns[Random().nextInt(nouns.length)],
      ));

  // 2
  static final MockRepository _instance = MockRepository._internal();
  factory MockRepository() => _instance;
  MockRepository._internal() : super();

  // 3
  Future<List<ExampleRecord>> queryRecords() async {
    await Future.delayed(const Duration(seconds: 2)); // 4
    return _store;
  }
}