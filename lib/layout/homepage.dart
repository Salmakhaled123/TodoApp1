import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archivedtasks/archivedScreen.dart';
import 'package:todoapp/modules/donetasks/doneScreen.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../modules/newtasks/newtasksScreen.dart';
import '../shared/components/constants.dart';
class HomeScreen extends StatelessWidget {
  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, Appstates>(
          listener: (context, state) {
            if(state is AppInsertdatabaseState)
              {
                Navigator.pop(context);
              }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text('${cubit.titles[cubit.currentIndex]}'),),
              body: state is! AppGetloadingState ?cubit.Screens[cubit.currentIndex]:Center(child: CircularProgressIndicator()) ,
              floatingActionButton: FloatingActionButton(onPressed: () {
                if (cubit.IsbottomsheetShown) {
                  if (formKey.currentState!.validate())
                  {
                    cubit.insertToDb(
                        title: titlecontroller.text,
                        date:datecontroller.text,
                        time: timecontroller.text);

                  }
                }
                else {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[300], padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Form(key: formKey,
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                defaultFormField(controller: titlecontroller,
                                    validate: (String ? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'please fill the task field';
                                      }
                                      return null;
                                    },

                                    type: TextInputType.text,

                                    prefix: Icons.title,
                                    label: 'Task title'),
                                SizedBox(height: 15.0,),
                                defaultFormField(
                                    prefix: Icons.watch_later_rounded,
                                    label: 'Task time',

                                    validate: (String ? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'please fill the time';
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                    type: TextInputType.datetime,
                                    ontap: () {
                                      showTimePicker(context: context,
                                          initialTime: TimeOfDay.now()).then((
                                          value) {
                                        timecontroller.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      }
                                      );
                                    },
                                    controller: timecontroller,
                                    readonly: true
                                ),
                                SizedBox(height: 20,),
                                defaultFormField(
                                  controller: datecontroller,

                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date mustn\'t be empty';
                                    }
                                    else {
                                      return null;
                                    }
                                  },
                                  type: TextInputType.datetime,
                                  readonly: true,
                                  ontap: () {
                                    showDatePicker(context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse(
                                            '2022-10-24')).then((value) {
                                      if (value != null) {
                                        datecontroller.text =
                                            DateFormat.yMMMd().format(
                                                value);
                                        print(DateFormat.yMMMd().format(
                                            value));
                                      }
                                    });
                                  },


                                  prefix: Icons.calendar_today,
                                  label: 'Task date',),
                              ],
                            ),
                          ),
                        ),
                      )).closed.then((value) {
                    cubit.changeBottomsheet(IsShown: false, icon: Icons.edit);

                  });
                  cubit.changeBottomsheet(IsShown:true, icon: Icons.add);

                }
              },
                  child: Icon(cubit.fab)),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);

                    // setState(()
                    // {
                    //   currentIndex=index;
                    //   print(index);
                    // });

                  },
                  items:
                  [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu), label: 'tasks'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.done_outlined), label: 'Done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive_outlined), label: 'Archived')

                  ])
              ,);
          }),

    );
  }
}
