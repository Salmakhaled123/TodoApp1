import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/donetasks/doneScreen.dart';
import 'package:todoapp/shared/cubit/states.dart';
import '../../modules/archivedtasks/archivedScreen.dart';
import '../../modules/newtasks/newtasksScreen.dart';

class AppCubit extends Cubit<Appstates>
{
  AppCubit():super(AppIntialStates());
  static AppCubit get(context)=>BlocProvider.of(context);//create object
  int currentIndex=0;
  List<Widget> Screens=const [ TasksScreen(), DoneTasksScreen(), ArchivedTasksScreen()];
  List<String> titles=['New tasks ', 'Done tasks', 'Archived tasks'];
  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppBottomNavBarState());
  }
  List<Map> newrecords=[];
  List<Map> donerecords=[];
  List<Map> archivedrecords=[];
 late Database  database;

  void createDB()
  {
    openDatabase('todo.db',version: 1,
        onCreate:(database,version)

        {
          print('database created');
          database.
          execute('CREATE TABLE TASKS (ID INTEGER PRIMARY KEY ,TITLE STRING,DATE STRING ,TIME STRING ,STATUS STRING)')
              .then((value)
          {
            print('table created');

          }).catchError((error)
          {
            print('error while creating table ${error.toString()}');
          });
        }//end create
        ,onOpen: (database)
        {
          getDataFromDb(database);
          print('database opened');
        }//end open only
    ).then((value)
    {
      database=value;
      emit(AppCreatedatabaseState());

    });//end of open database
  }
  IconData fab = Icons.edit;
  bool IsbottomsheetShown = false;
  void changeBottomsheet({required bool IsShown,required IconData icon})
  {

    IsbottomsheetShown=IsShown;
    fab=icon;
    emit(AppChnagebottomsheetState());

  }

  insertToDb({required String title,required String date,required String time})  async
  {
    await  database.transaction((txn)
    {
      return  txn.rawInsert('INSERT INTO TASKS (TITLE,DATE,TIME,STATUS) VALUES ("${title}","${date}","${time}","new")').then((value)
      {
        print('${value} inserted successfully');
        emit(AppInsertdatabaseState());
        getDataFromDb(database);
          emit(AppGetdatabaseState());

        });

      }).catchError((error)
      {
        print('error in insertion');
      });

    }


  void getDataFromDb(database)
  {
    newrecords=[];
    archivedrecords=[];
    donerecords=[];
    emit(AppGetloadingState());
     database.rawQuery('SELECT * FROM TASKS')..then((value)
     {

       value.forEach((element)
       {
         if(element['STATUS']=='new')
           {
             newrecords.add(element);
           }
         else if(element['STATUS']=='done')
           {
             donerecords.add(element);
           }
         else
           {
             archivedrecords.add(element);
           }
       });

       emit(AppGetdatabaseState());


     });

  }
  void updatedata({required String status,required int id})async
  {

   database.rawUpdate('UPDATE TASKS SET STATUS=? WHERE ID =? ',[status,id]).
   then((value)
   {
     getDataFromDb(database);
     emit(AppUpdatedataState());
   });

  }
  void deletedata({required int id})async
  {

    database.rawDelete('DELETE FROM TASKS WHERE ID = ?', [id]).
    then((value)
    {
      getDataFromDb(database);
      emit(AppdeletedataState());

    });

  }
}


