import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:provider/provider.dart';

class LogInButton extends StatelessWidget {
  final Color color,textColor;
  final String title;
  final Function onPressed;
  LogInButton({this.title,this.color,@required this.onPressed,this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.teal,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.circular(30.0),
        ),

        child: MaterialButton(
          onPressed: onPressed!=null?onPressed:(){},
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color:textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class AddTask extends StatelessWidget {
  final String label;
  final Function onTap;
  const AddTask({this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}


FloatingActionButton floatingAddButton(context){
  return FloatingActionButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: Colors.black,
    onPressed: ()async {
      await Get.to(AddTaskPage()).then((value) {
        Provider.of<TaskProvider>(context,listen: false).getTasks();
      });
    },
    child: Icon(Icons.add, size: 30,),
  );
}


