import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
Widget defaultButton({
  double width = double.infinity,
  bool isUpper = true,
  Color background = Colors.blue,
  required Function function,
  required String text,
  double radius = 0.0,
}) =>
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: background),
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller
  , required TextInputType type,
  Function (String)? onsubmit,
  Function (String) ? onchanged,
  required FormFieldValidator<String>?validate,
  required IconData prefix,
  required String label,
  bool  Ispassword=false,
  IconData ?suffix,
  bool readonly=false,
  GestureTapCallback? ontap,
  final VoidCallback? suffixpressed
})=>TextFormField(readOnly:readonly ,
  onTap:ontap ,
  validator: validate,
  obscureText:Ispassword ,
  controller: controller,
  decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),suffixIcon:suffix !=null ? IconButton(icon: Icon(suffix),
    onPressed: suffixpressed,): null ,
      border:const  OutlineInputBorder()),
  onFieldSubmitted:onsubmit ,
  onChanged: onchanged
  ,);
Widget buildItem(Map map) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      CircleAvatar(radius: 35.0,
        child: Text('${map['TIME']}'),),
      const SizedBox(width: 16.0,),
      Column(mainAxisSize: MainAxisSize.min,
        children: [
          Text('${map['TITLE']}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )
          ),
          Text('${map['DATE']}',
              style: const TextStyle(
                  fontSize: 16.0,

                  color: Colors.grey
              )
          )
        ],)
    ],),
  );
}
Widget buildTaskItem(Map map,context)=>Dismissible(
  key:Key(map['ID'].toString()),
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(children:
  
    [
  
      CircleAvatar(radius: 40,
  
        child: Text('${map['TIME']}'),),
  
      SizedBox(width: 20,),
  
      Expanded(
  
        child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
  
          children: [
  
            Text('${map['TITLE']}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
  
  
  
            Text('${map['DATE']}',style: TextStyle(color: Colors.grey),),
  
  
  
          ],),
  
      ),
  
      SizedBox(width: 20,),
  
      IconButton(onPressed: ()
  
      {
  
        AppCubit.get(context).updatedata(status: 'done', id: map['ID']);
  
      },
  
          icon: Icon(Icons.check_box_rounded,
  
          color: Colors.green,)),
  
      IconButton(onPressed: ()
  
      {
  
        AppCubit.get(context).updatedata(status: 'archive', id: map['ID']);
  
      },
  
          icon: Icon(Icons.archive,
  
          color: Colors.black45,))
  
  
  
    ],),
  
  ),onDismissed: (direction)
  {
  AppCubit.get(context).deletedata(id: map['ID']);

  },
);
Widget taskBuilder({required List<Map> tasks})
{
  if(tasks.length >0)
    {
      return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          itemCount:tasks.length,
          separatorBuilder: (context, index) =>
              Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300]));
    }
  else
    {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Icon(Icons.menu,color: Colors.grey[300],size: 100,),
            Text('No tasks yet please add tasks',style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),)

          ],),
      );
    }
}