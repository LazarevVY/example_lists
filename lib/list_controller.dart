// Описание кода:
// 1
// Вызов super устанавливает исходное состояние списка.
// 2
// При создании контроллера инициируем процесс получения содержимого списка.
// 3
// Функция получения данных, которыми будет заполняться список. Не получаем
// данные напрямую из репозитория, так как кроме самих данных иногда требуется
// определять дополнительных характеристики этих данных, например, является ли
// возвращаемый результат окончанием списка (в случае, если получаем список
// частями).
// 4
// Функция, ответственная за загрузку данных для списка и изменения состояния
// списка в процессе загрузки.
// 5
// Игнорируем новые запросы на загрузку списка, пока предыдущий запрос не завершён.
// 6
// В состоянии списка указываем, что список в процессе загрузки. Сбрасываем
// описание ошибки, если такая имелась после предыдущей загрузки.
// 7
// Если получение записей прошло успешно, добавляем их в состояние списка.
// Также в состоянии списка указываем, что загрузка списка завершена.
// 8
// Если что-то пошло не так, добавляем в состояние списка сообщение об ошибке.
// 9
// Функция будет использоваться для повторной попытки получения списка записей,
// если во время предыдущей попытки возникла ошибка. Не используем функцию
// loadRecords, так как в следующих частях статьи функция repeatQuery будет
// дорабатываться.


import 'list_state.dart';
import 'models.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart';

class ListController extends ValueNotifier<ListState> {
  final ExampleRecordQuery query; // +
  ListController({required this.query}) : super(ListState()) { // 1
    loadRecords(query: query); // 2 *
  }

  // 3
  Future<List<ExampleRecord>> fetchRecords(ExampleRecordQuery? query) async {
    final loadedRecords = await MockRepository().queryRecords(query);
    return loadedRecords;
  }

  // 4
  Future<void> loadRecords({ExampleRecordQuery? query}) async {
    if (value.isLoading) return; // 5

    value = value.copyWith(isLoading: true, error: ""); // 6

    try {
      final fetchResult = await fetchRecords(query);

      value = value.copyWith(isLoading: false, records: fetchResult); // 7
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString()); // 8
      rethrow;
    }
  }

  // 9
  repeatQuery() {
    return loadRecords(query: query);
  }
}