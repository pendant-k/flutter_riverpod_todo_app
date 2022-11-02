import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_study/providers/todo_filter.dart';

import 'providers/todos_notifier.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MyWidget());
  }
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoFilterProvider);
    final todos = ref.watch(todosProvider);
    final filteredTodoProvider = Provider<List<Todo>>((ref) {
      switch (filter) {
        case TodoFilter.all:
          return todos;
        case TodoFilter.todo:
          return todos.where((e) => !e.done).toList();
        case TodoFilter.done:
          return todos.where((e) => e.done).toList();
      }
    });

    final filteredTodos = ref.watch(filteredTodoProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'TODO APP by Riverpod',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 20,
        ),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.grey[900],
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '새로운 할 일 작성',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    autofocus: true,
                    decoration: const InputDecoration(),
                    onSubmitted: (value) {
                      ref.read(todosProvider.notifier).addTodo(
                            Todo(
                                id: Random().nextInt(1000).toString(),
                                desc: value,
                                done: false),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: Container(
          color: Colors.black,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        ref.read(todoFilterProvider.notifier).clearFilter();
                      },
                      child: Text(
                        'All',
                        style: TextStyle(
                          fontSize: 15,
                          color: ref.watch(todoFilterProvider) == TodoFilter.all
                              ? Colors.orange
                              : Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(todoFilterProvider.notifier).showTodo();
                      },
                      child: Text(
                        'Todo',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              ref.watch(todoFilterProvider) == TodoFilter.todo
                                  ? Colors.orange
                                  : Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(todoFilterProvider.notifier).showDone();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              ref.watch(todoFilterProvider) == TodoFilter.done
                                  ? Colors.orange
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (filteredTodos.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, idx) {
                      return Container(
                        color: Colors.grey[900],
                        child: CheckboxListTile(
                            title: Text(
                              filteredTodos[idx].desc,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            value: filteredTodos[idx].done,
                            onChanged: (_) {
                              ref
                                  .read(todosProvider.notifier)
                                  .toggle(filteredTodos[idx].id);
                            }),
                      );
                    },
                  ),
                ),
              if (todos.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    '할 일 목록을 작성해보세요',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          )),
    );
  }
}
