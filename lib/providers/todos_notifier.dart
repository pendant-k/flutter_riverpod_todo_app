import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// immutable 속성의 todo data class 생성
@immutable
class Todo {
  final String id;
  final String desc;
  final bool done;

  const Todo({
    required this.id,
    required this.desc,
    required this.done,
  });

  // immutable하지만 업데이트를 위해서 copyWith method 만들기

  Todo copyWith({
    String? id,
    String? desc,
    bool? done,
  }) {
    return Todo(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      done: done ?? this.done,
    );
  }
}

// 현재 저장된 할 일 목록을 저장해두는 StateNotifierProvider
class TodosNotifier extends StateNotifier<List<Todo>> {
  // initial value 지정 -> []
  TodosNotifier() : super([]);

  // Add new Todo to state
  void addTodo(Todo newTodo) {
    // We don't need to use some functions like notifyListeners()
    state = [...state, newTodo];
  }

  // remove exist Todo from state
  void removeTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id != id) todo,
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(done: !todo.done) else todo,
    ];
  }
}

// StateNotifier값을 제공하는 provider 객체 생성
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
