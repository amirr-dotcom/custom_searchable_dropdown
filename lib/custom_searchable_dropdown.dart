library custom_searchable_dropdown;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class customSearchableDropDown extends StatefulWidget {
  List items=[];
  String label;
  String hint='';
  Widget prefixIcon;
  bool hideSearch;
  bool multiSelect;
  bool multiSelectValuesAsWidget;
  String itemOnDialogueBox;
  Decoration decoration;
  List dropDownMenuItems=[];
  final ValueChanged onChanged;

  customSearchableDropDown({
    @required this.items,
    @required this.label,
    this.onChanged,
    this.hint,
    this.itemOnDialogueBox,
    this.dropDownMenuItems,
    this.prefixIcon,
    this.multiSelect,
    this.multiSelectValuesAsWidget,
    this.hideSearch,
    this.decoration,
  });

  @override
  _customSearchableDropDownState createState() => _customSearchableDropDownState();
}

class _customSearchableDropDownState extends State<customSearchableDropDown> {



  String onSelectLabel=null;
  final searchC = TextEditingController();
  List  menuData = [];
  List  mainDataListGroup = [];
  List  newDataList = [];

  List selectedValues=[];



  @override
  Widget build(BuildContext context) {
    if(widget.items.isEmpty)
    {
      onSelectLabel=null;
      widget.onChanged(null);
    }
    return  Container(
      decoration: widget.decoration,
      child: FlatButton(
        padding: EdgeInsets.all(8),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        height: 0,
        child: Row(
          children: [
            widget.prefixIcon==null? Container():widget.prefixIcon,
            ((widget.multiSelect==true && widget.multiSelect!=null) && selectedValues.isNotEmpty)?
            Expanded(
                child: (widget.multiSelectValuesAsWidget==true && widget.multiSelectValuesAsWidget!=null)?

                Wrap(
                  children: List.generate(
                    selectedValues.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5,3,5,3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:  BorderRadius.all(Radius.circular(0.0),)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5,2,5,2),
                                child: Text(selectedValues[index].split('-_-')[0].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                  ),),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    :Text(selectedValues.length==1?selectedValues.length.toString()+ ' value selected':
                selectedValues.length.toString()+' values selected',
                  style: TextStyle(
                      color: Colors.grey
                  ),)
            ):
            Expanded(child: Text(onSelectLabel==null? widget.label==null?
            'Select Value':widget.label:onSelectLabel,
              style: TextStyle(
                color: onSelectLabel==null? Colors.grey[600]:Colors.grey[800],
              ),)),
            Icon(Icons.arrow_drop_down,
              color: widget.items.isEmpty? Colors.grey: Colors.black,)
          ],
        ),
        onPressed: (){
          menuData.clear();
          if(widget.items.isNotEmpty)
          {
            for(int i=0; i<widget.dropDownMenuItems.length; i++)
            {
              menuData.add(widget.dropDownMenuItems[i].toString()+'-_-'+i.toString());
            }
            mainDataListGroup=menuData;
            newDataList=mainDataListGroup;
            searchC.clear();
            showDialogueBox(context);
          }
        },
      ),
    );
  }





  Future<void> showDialogueBox(context) async{

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (context,setState)
              {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: widget.multiSelect==null? false:widget.multiSelect,
                              child: Row(
                                children: [
                                  FlatButton(
                                    child: Text('Select All',
                                      style: TextStyle(
                                          color: Colors.blue
                                      ),),
                                    onPressed: (){
                                      selectedValues.clear();
                                      for(int i=0; i<newDataList.length; i++)
                                      {
                                        selectedValues.add(newDataList[i]);
                                      }
                                      setState(() {
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Clear All',
                                      style: TextStyle(
                                          color: Colors.blue
                                      ),),
                                    onPressed: (){
                                      setState(() {
                                        selectedValues.clear();
                                      });
                                    },
                                  ),
                                ],
                              )
                          ),
                          Visibility(
                            visible: widget.hideSearch==null? true:!widget.hideSearch,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8,0,8,8),
                              child: TextField(
                                controller: searchC,
                                autofocus: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search,
                                    color: Colors.blue,),
                                  hintText: 'Search Here...',
                                ),
                                onChanged:(v){
                                  onItemChanged(v);
                                  setState((){

                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder
                              (
                                itemCount: newDataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Visibility(
                                              visible: widget.multiSelect==null? false:widget.multiSelect,
                                              child: Checkbox(
                                                  value: selectedValues.contains(newDataList[index])? true: false,
                                                  activeColor: Colors.green,
                                                  onChanged:(newValue){
                                                    if(selectedValues.contains(newDataList[index])){
                                                      setState(() {
                                                        selectedValues.remove(newDataList[index]);
                                                      });
                                                    }
                                                    else{
                                                      setState(() {
                                                        selectedValues.add(newDataList[index]);
                                                      });
                                                    }
                                                  }),
                                            ),
                                            Expanded(
                                              child: Text(newDataList[index].split('-_-')[0].toString(),
                                                style: TextStyle(
                                                    color: Colors.grey[700]
                                                ),),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          if(widget.multiSelect==true && widget.multiSelect!=null)
                                          {
                                            if(selectedValues.contains(newDataList[index])){
                                              setState(() {
                                                selectedValues.remove(newDataList[index]);
                                              });
                                            }
                                            else{
                                              setState(() {
                                                selectedValues.add(newDataList[index]);
                                              });
                                            }
                                          }
                                          else{
                                            for( int i=0; i<menuData.length; i++)
                                            {
                                              if(menuData[i]==newDataList[index])
                                              {
                                                onSelectLabel=menuData[i].split('-_-')[0].toString();
                                                widget.onChanged(widget.items[i]);
                                              }
                                            }
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                child: Text('Close',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                              Visibility(
                                visible: (widget.multiSelect==true && widget.multiSelect!=null),
                                child: FlatButton(
                                  child: Text('Done',
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),),
                                  onPressed: (){
                                    var sendList=[];
                                    for( int i=0; i<menuData.length; i++)
                                    {
                                      if(selectedValues.contains(menuData[i]))
                                      {
                                        sendList.add(widget.items[i]);
                                      }
                                    }
                                    print(sendList);
                                    widget.onChanged(jsonEncode(sendList));
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

          );
        }).then((valueFromDialog){
      // use the value as you wish
      setState(() {

      });
    });
  }



  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataListGroup
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }


}






