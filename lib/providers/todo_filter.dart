import 'package:flutter_riverpod/flutter_riverpod.dart';

// State for current focused Filter

// define TodoFilter enum type
enum TodoFilter {
  all,
  todo,
  done,
}

// state 값을 저장하고, 수정하기위해 StateNotifierProvider를 활용한다.
// TodoFilter 값을 저장하는 StateNotifier
class TodoFilterNotifier extends StateNotifier<TodoFilter> {
  // set init value
  TodoFilterNotifier() : super(TodoFilter.all);

  // state 값을 수정하기위한 methods (notifier)

  clearFilter() {
    state = TodoFilter.all;
  }

  showTodo() {
    state = TodoFilter.todo;
  }

  showDone() {
    state = TodoFilter.done;
  }
}

// 위에서 작성한 코드를 베이스로 Provider object를 생성한다.
// 현재 포커싱된 필터가 무엇인지에 대한 state를 가진 Provider이다.
final todoFilterProvider =
    StateNotifierProvider<TodoFilterNotifier, TodoFilter>(
  (ref) => TodoFilterNotifier(),
);
