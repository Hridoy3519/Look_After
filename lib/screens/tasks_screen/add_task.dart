import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/controllers/task_controller.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/input_field.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //const AddTaskPage({Key? key}) : super(key: key);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
    30,
    60
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly"
  ];

  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  )
              ),
              MyInputField(title: "Title", hint: "Enter Your Title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter Your Note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey,),
                  onPressed: (){
                    _getDateFromUser();
              },
                ),),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(true);
                          },
                          icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                        ),
                      )
                  ),
                  SizedBox(width: 12),
                  Expanded(
                      child: MyInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(false);
                          },
                          icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                        ),
                      )
                  )
                ],
              ),
              MyInputField(title: "Remindeer", hint: "$_selectedRemind minutes early",
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                underline: Container(
                  height: 0,
                ),
                onChanged: (String newValue){
                  setState(() {
                    _selectedRemind = int.parse(newValue);
                  });
                },
                items:remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }

                ).toList(),
              ),
              ),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                underline: Container(
                  height: 0,
                ),
                onChanged: (String newValue){
                  setState(() {
                    _selectedRepeat = newValue;
                  });
                },
                items:repeatList.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(
                      color: Colors.grey
                    )),
                  );
                }

                ).toList(),
              ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  AddTask(label: "Create Task", onTap: ()=>_validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      _addTaskToDb();
      NotifyHelper().displayNotification(
        title: "Your Task Has been Added",
        body: _noteController.text
      );
      Get.back();
    }else{
      Get.snackbar("Required", "All Fields are Required",
      snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.pink,
        icon: Icon(Icons.warning_amber_rounded)
      );
    }
  }
  _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/hridoy.png"),
        ),
        SizedBox(width: 10,),
      ],
    );
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 18),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int indx){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedColor = indx;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      child: _selectedColor==indx?Icon(Icons.done,
                        color: Colors.white,
                        size: 16,):Container(),
                      radius: 14,
                      backgroundColor: indx==0?Colors.blue:indx==1?Colors.pink:Colors.yellow,
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );
  }
  _getDateFromUser() async{
    DateTime _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2115)
    );
    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{

    }
  }

  _getTimeFromUser(bool isStartTime) async{
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if(_pickedTime==null){

    }else if(isStartTime == true){
      setState(() {
        _startTime = _formatedTime;
      });
    }else{
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }
  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])
    )
    );
  }

  _addTaskToDb() async{

    Task ts = Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    );

    DateTime date = DateFormat.jm().parse(ts.startTime.toString());
    var myTime = DateFormat("HH:mm").format(date);
    int hour = int.parse(myTime.toString().split(":")[0]);
    int minute = int.parse(myTime.toString().split(":")[1]);
    FlutterAlarmClock.createAlarm(hour, minute);


    int value = await TaskProvider().addTask(
        task: ts
    );

    print("My id is: " + "$value");
  }
}
