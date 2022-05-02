// Описание кода:
// 1
// Иногда интерфейс приложения должен по-разному информировать пользователя
// о загрузке данных в случаях, если происходит обновление всего списка,
// либо подгружается его часть. Данное перечисление содержит возможные цели
// загрузки данных для списка.
// 2
// Переменная указывает загружен ли список целиком. Она должна содержать
// значение true, когда в список добавлена последняя страница с данными.
// 3
// Проверки на невозможные состояния списка. Чтобы отладка кода был проще,
// лучше такие состояния отлавливать как можно раньше.

import 'models.dart';

enum LoadingFor { idle, replace, add } // + 1

class ListState {
  ListState({
    List<ExampleRecord>? records,
    this.loadingFor = LoadingFor.idle,
    this.hasLoadedAllRecords = false, // + 2
    this.error = '',
  }) : recordsStore = records {
    // 3
    if (isInitialized && !hasLoadedAllRecords && this.records.isEmpty) { // + 
      throw Exception("Wrong list state: list is empty but has no loadedAllRecords marker"); // +
    } // + 
    if (hasLoadedAllRecords && hasError) { // + 
      throw Exception("Wrong list state: state with hasLoadedAllRecords marker must not contain error ($error)"); // +
    } // + 
  }

  final LoadingFor loadingFor; // *
  final bool hasLoadedAllRecords; // +

  final List<ExampleRecord>? recordsStore;

  bool get isInitialized => recordsStore != null;

  List<ExampleRecord> get records => recordsStore ?? List<ExampleRecord>.empty();

  final String error;

  bool get hasError => error.isNotEmpty;

  bool get isLoading => loadingFor != LoadingFor.idle; // +

  bool canLoadMore() => !hasLoadedAllRecords && !isLoading && !hasError; // +

  ListState copyWith({
    List<ExampleRecord>? records,
    LoadingFor? loadingFor, // *
    bool? hasLoadedAllRecords, // +
    String? error,
  }) {
    return ListState(
      records: records ?? recordsStore,
      loadingFor: loadingFor ?? this.loadingFor, // +
      hasLoadedAllRecords: hasLoadedAllRecords ?? this.hasLoadedAllRecords, // +
      error: error ?? this.error,
    );
  }
}
