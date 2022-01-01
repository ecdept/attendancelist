import 'dart:async';
import 'package:attedance/studentmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'homescreen.dart';



late  Box<StudentModel> studentDB;
List<String> allrollnos=[];
var map = Map();

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final document=await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  if(!Hive.isAdapterRegistered(1)){
    Hive.registerAdapter(StudentModelAdapter());
  }
  studentDB= await Hive.openBox<StudentModel>('name');
  //studentDB=Hive.box<StudentModel>('name');
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.orange[150],
      home:splashScreen(),
    );
  }
}
class splashScreen extends StatefulWidget {

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3), (){
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){return HomeScreen();}));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Image.asset('assets/rjtech.png')),
      ),
    );
  }
}

