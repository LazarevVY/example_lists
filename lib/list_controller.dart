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

// Описание (модифицированного для порционной загрузки) кода:
// 1
// Для того, чтобы функция fetchRecords могла возвращать не только список
// записей, но ещё и информацию о том, является ли возвращаемый результат
// окончанием списка, используем в качестве возвращаемого значения этой функции
// объект класса _FetchRecordsResult.
// 2
// Так как теперь список может загружаться и целиком, и частями, указываем это
// через параметр replace функции loadRecords.
// 3
// Отображаем цель загрузки списка (целиком или частями) в его состоянии.
// 4
// Функция будет вызываться, когда необходимо получить следующую
// страницу записей списка.
// 5
// Функция формирует объект запроса для получения следующей страницы списка.
// 6
// Дополнительная проверка на уместность вызова функции getNextRecordsQuery.
// Нет смысла получать следующую страницу списка, если он пуст.
// 7
// Модифицируем запрос таким образом, чтобы функция queryRecords вернула данные,
// у которых значение параметра, по которому идёт сортировка, было больше, чем у
// такого же параметра последней записи текущего списка.
// 8
// Во время повторной попытки получения данных определяем способ, которым они
// получались в предыдущий раз. Делается это на основании того, есть ли записи
// в текущем состоянии списка. Альтернативный подход — сохранять последний
// выполненный запрос ExampleRecordQuery в состоянии списка ListState.

import 'list_state.dart';
import 'models.dart';
import 'repository.dart';
import 'package:flutter/foundation.dart';

// 1
class _FetchRecordsResult<T> { // +
  final List<ExampleRecord> records; // +
  final bool loadedAllRecords; // +

  _FetchRecordsResult({required this.records, required this.loadedAllRecords}); // +
} // +

class ListController extends ValueNotifier<ListState> {
  final ExampleRecordQuery query; // +
  ListController({required this.query}) : super(ListState()) { // 1
    loadRecords(query: query); // 2 *
  }

  // 3
  Future<_FetchRecordsResult> fetchRecords(ExampleRecordQuery? query) async {
    final loadedRecords = await MockRepository().queryRecords(query);
    //return loadedRecords;
    return _FetchRecordsResult(records: loadedRecords, loadedAllRecords: loadedRecords.length < kBatchSize); // *
  }

  // 4
  Future<void> loadRecords({ExampleRecordQuery? query, bool replace = true}) async {
    if (value.isLoading) return; // 5

    value = value.copyWith(loadingFor: replace ? LoadingFor.replace : LoadingFor.add, error: ""); // * 3 // 6

    try {
      final fetchResult = await fetchRecords(query);
      final records = [ // +
        if (!replace) ...value.records, // +
        ...fetchResult.records, // +
      ]; // +

      value = value.copyWith(loadingFor: LoadingFor.idle, records: records, hasLoadedAllRecords: fetchResult.loadedAllRecords); // *
    } catch (e) {
      value = value.copyWith(loadingFor: LoadingFor.idle, error: e.toString()); // *
      rethrow;
    }
  }

  // 9
  repeatQuery() {
    return loadRecords(query: query);
  }
  directionalLoad() async { // + 4
    final query = getNextRecordsQuery(); // +
    await loadRecords(query: query, replace: false); // +
  } // +

  ExampleRecordQuery getNextRecordsQuery() { // + 5
    if (value.records.isEmpty) throw Exception("Impossible to create query"); // + 6
    return query.copyWith(weightGt: value.records.last.weight); // + 7
  } // +
}