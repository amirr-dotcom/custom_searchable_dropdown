import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Custom Searchable DropDown Demo',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List listToSearch=[
    {
      'name': 'Amir',
      'class': 12
    },
    {
      'name': 'Raza',
      'class': 11
    },
    {
      'name': 'Praksh',
      'class': 10
    },
    {
      'name': 'Nikhil',
      'class': 9
    },
    {
      'name': 'Sandeep',
      'class': 8
    },
    {
      'name': 'Tazeem',
      'class': 7
    }
  ];

  var selected;
  List selectedList;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            Text('Select a value'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customSearchableDropDown(
                items: listToSearch,
                label: 'Select Subject',
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue
                    )
                ),
                prefixIcon:  Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(Icons.search),
                ),
                dropDownMenuItems: listToSearch?.map((item) {
                  return item['name'];
                })?.toList() ??
                    [],
                onChanged: (value){
                  if(value!=null)
                  {
                    selected = value['class'].toString();
                  }
                  else{
                    selected=null;
                  }
                },
              ),
            ),
            Text('Select Multiple values show selected value.'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customSearchableDropDown(
                items: listToSearch,
                label: 'Select Subject',
                multiSelectValuesAsWidget: true,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue
                    )
                ),
                multiSelect: true,
                prefixIcon:  Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(Icons.search),
                ),
                dropDownMenuItems: listToSearch?.map((item) {
                  return item['name'];
                })?.toList() ??
                    [],
                onChanged: (value){
                  if(value!=null)
                  {
                    selectedList = jsonDecode(value);
                  }
                  else{
                    selectedList.clear();
                  }
                },
              ),
            ),
            Text('Select Multiple values'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customSearchableDropDown(
                items: listToSearch,
                label: 'Select Subject',
                multiSelectValuesAsWidget: false,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue
                  )
                ),
                multiSelect: true,
                prefixIcon:  Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(Icons.search),
                ),
                dropDownMenuItems: listToSearch?.map((item) {
                  return item['name'];
                })?.toList() ??
                    [],
                onChanged: (value){
                  if(value!=null)
                  {
                    selectedList = jsonDecode(value);
                  }
                  else{
                    selectedList.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
