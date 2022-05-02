// Описание кода:
// 1
// Переменная для хранения строки поиска.
// 2
// Функция проверки соответствия объекта obj условиями фильтрации.
// 3
// Функция сравнения и определения порядка следования записей record1 и record2.

class ExampleRecord {
  final String title;
  final int weight; // +

  const ExampleRecord({
    required this.title,
    required this.weight, // +
  });
}

class ExampleRecordQuery {
  final String? contains; // 1

  const ExampleRecordQuery({
    this.contains,
  });

  // 2
  bool suits(ExampleRecord obj) {
    if (contains != null && contains!.isNotEmpty && !obj.title.contains(contains!)) return false;
    return true;
  }

  // 3
  int compareRecords(ExampleRecord record1, ExampleRecord record2) {
    return record1.weight.compareTo(record2.weight);
  }
}
