//import 'package:flutter/cupertino.dart';
//import 'dart:html';

import 'package:attedance/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'main.dart';
final datecontrlr = TextEditingController();
final attendancecontrlr = TextEditingController();
final _formKey=GlobalKey<FormState>();

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATTENDANCE CALCULATOR'),
        actions: [
          IconButton(onPressed: () {
            studentDB.clear();
          }, icon: Icon(Icons.logout)),
        ],
      ),
      body:  Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            //shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Enter Date in DD/MM/YYYY format';
                  }
                },
                controller: datecontrlr,
                decoration: const InputDecoration(
                  hintText: 'Date(DD/MM/YYYY)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Enter roll nos separated by coma';
                  }
                },
                controller: attendancecontrlr,
                decoration: const InputDecoration(
                  hintText: 'Enter Absentees Roll Nos(eg: 1,2)',
                  border: OutlineInputBorder(),
                ),

              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80.0,right: 80),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    ElevatedButton(onPressed: (){
                      if( _formKey.currentState!.validate()){
                        savemarkstodb();

                      }
                    }, child: Text('Add')),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(onPressed: (){
                      takeallitems();
                      var map = Map();

                      for (var element in allrollnos) {
                        if(!map.containsKey(element)) {
                          map[element] = 1;
                        } else {
                          map[element] +=1;
                        }
                      }
                      print(map.length);
                      var totalhour=studentDB.length;
                      List<Widget> newlist=_buildRow(map,totalhour);
                      showDialog(context: context, builder: (ctx){

                        allrollnos.clear();
                        return AlertDialog(
                          title: Text('       Final Attendance'),

                          content: Column(

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Total Hours:$totalhour'),
                              Text(' R.Nos    Percentage',style: TextStyle(color:Colors.orange ),),

                              ...newlist,

                              Text('(All other roll numbers have 100% attendance)'),
                            ],
                          ),
                        );
                      }
                      );

                    }, child: Text('Calculate')),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: studentDB.listenable(),
                builder: (BuildContext context,Box<StudentModel> values, Widget? child) {
                  final keys=values.keys.toList();
                  return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,index){
                        final name=values.get(keys[index])!.date;
                        final mark1=values.get(keys[index])!.attendance;

                        return ListTile(
                          //onTap: (){},
                          title: Text(name),
                          subtitle: Text(mark1.toString()),
                          trailing: IconButton(onPressed: () {
                            values.delete(keys[index]);
                          }, icon: Icon(Icons.delete),),
                        );
                      },
                      separatorBuilder: (BuildContext context,index){
                        return const Divider(thickness: 5,);

                      },
                      itemCount: values.length);
                },

              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> savemarkstodb()async {
    final date=datecontrlr.text;
    final attendance=attendancecontrlr.text;
    var mk=attendance.toString();
    List<String> attendancelist=mk.split(",");

    final studentmodel= StudentModel(date: date, attendance: attendancelist);

    studentDB.add(studentmodel);


  }
  List<Widget> _buildRow(Map map, int totalhour) {
    List<Widget> widgets = [];
    map.forEach((k, v) {
      double p=((totalhour-v)/totalhour)*100;
      String Percentage=p.toStringAsFixed(2);
      widgets.add(
        Text(

          '$k:              $Percentage',style: TextStyle(color: Colors.red),
        ),
      );
    });
    return widgets;
  }

  void takeallitems() {
    for(int i=0;i<studentDB.length;i++){
      allrollnos.addAll(studentDB.get(i)!.attendance);
    }
  }


}
