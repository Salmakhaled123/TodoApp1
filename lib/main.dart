import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/layout/homepage.dart';

import 'shared/bloc_observer.dart';

void main()
{
  Bloc.observer = MyBlocObserver();
  runApp(TodoApp());
}
class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:HomeScreen(),debugShowCheckedModeBanner: false,);
  }
}


