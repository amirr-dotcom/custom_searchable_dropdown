library custom_searchable_dropdown;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSearchableDropDown<T> extends StatefulWidget {
  final List items;
  final List? initialValue;
  final String? label;
  final String hint;
  final String? multiSelectTag;
  final int? initialIndex;
  final Widget? prefixIcon;
  final bool hideSearch;
  final bool enabled;
  final bool menuMode;
  final bool showClearButton;
  final bool multiSelect;
  final bool multiSelectValuesAsWidget;
  final String? itemOnDialogueBox;
  final Decoration? decoration;
  final List? dropDownMenuItems;
  final ValueChanged? onChanged;

  CustomSearchableDropDown({
    required this.items,
    required this.label,
    this.onChanged,
    this.hint = '',
    this.initialValue,
    this.enabled = true,
    this.showClearButton = false,
    this.itemOnDialogueBox,
    this.dropDownMenuItems,
    this.prefixIcon,
    this.menuMode = false,
    this.initialIndex,
    this.multiSelect = false,
    this.multiSelectTag,
    this.multiSelectValuesAsWidget = true,
    this.hideSearch = true,
    this.decoration,
  });

  @override
  _CustomSearchableDropDownState createState() =>
      _CustomSearchableDropDownState();
}

class _CustomSearchableDropDownState extends State<CustomSearchableDropDown> {
  String? onSelectLabel;
  final searchC = TextEditingController();
  List menuData = [];
  List mainDataListGroup = [];
  List newDataList = [];

  List selectedValues = [];

  GlobalKey _key = LabeledGlobalKey("button_icon");
  OverlayEntry? _overlayEntry;
  late Size buttonSize;
  late Offset buttonPosition;
  bool isMenuOpen = false;

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry!.remove();
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    if (widget.initialIndex != null && widget.dropDownMenuItems!.isNotEmpty) {
      onSelectLabel =
          widget.dropDownMenuItems![widget.initialIndex!].toString();
    }
    if (widget.initialValue != null && widget.items.isNotEmpty) {
      for (int i = 0; i < widget.items.length; i++) {
        if (widget.initialValue![0]['id'] ==
            widget.items[i][widget.initialValue![0]['param']]) {
          onSelectLabel = widget.dropDownMenuItems![i].toString();
        }
      }
    }
    if (widget.items.isEmpty) {
      onSelectLabel = null;
      selectedValues.clear();
      widget.onChanged!(null);
    }
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 300,
              child: mainScreen(),
            ),
          ),
        );
      },
    );
  }

  findButton() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

//   if (isMenuOpen) {
//   closeMenu();
//   } else {
//   openMenu();
//   }
// }

  @override
  Widget build(BuildContext context) {
    if (widget.initialIndex != null && widget.dropDownMenuItems!.isNotEmpty) {
      onSelectLabel =
          widget.dropDownMenuItems![widget.initialIndex!].toString();
    }
    if (onSelectLabel == null) {
      if (widget.initialValue != null && widget.items.isNotEmpty) {
        for (int i = 0; i < widget.items.length; i++) {
          if (widget.initialValue![0]['id'] ==
              widget.items[i][widget.initialValue![0]['param']]) {
            onSelectLabel = widget.dropDownMenuItems![i].toString();
            print(onSelectLabel);
            setState(() {});
          }
        }
      }
    }
    if (widget.items.isEmpty) {
      onSelectLabel = null;
      selectedValues.clear();
      widget.onChanged!(null);
      setState(() {});
    }
    return Container(
      decoration: widget.decoration,
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Row(
            children: [
              widget.prefixIcon == null
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        13,
                        0,
                      ),
                      child: widget.prefixIcon,
                    ),
              ((widget.multiSelect) && selectedValues.isNotEmpty)
                  ? Expanded(
                      child: (widget.multiSelectValuesAsWidget)
                          ? Wrap(
                              children: List.generate(
                                selectedValues.length,
                                (index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 3, 5, 3),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0.0),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 2, 5, 2),
                                        child: Text(
                                          selectedValues[index]
                                              .split('-_-')[0]
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Text(
                              selectedValues.length == 1
                                  ? widget.multiSelectTag == null
                                      ? selectedValues.length.toString() +
                                          ' values selected'
                                      : selectedValues.length.toString() +
                                          ' ' +
                                          widget.multiSelectTag! +
                                          ' selected'
                                  : widget.multiSelectTag == null
                                      ? selectedValues.length.toString() +
                                          ' values selected'
                                      : selectedValues.length.toString() +
                                          ' ' +
                                          widget.multiSelectTag! +
                                          ' selected',
                              style: TextStyle(color: Colors.grey),
                            ))
                  : Expanded(
                      child: Text(
                        onSelectLabel == null
                            ? widget.label == null
                                ? 'Select Value'
                                : widget.label!
                            : onSelectLabel!,
                        style: TextStyle(
                          color: onSelectLabel == null
                              ? Colors.grey[600]
                              : Colors.grey[800],
                        ),
                      ),
                    ),
              Visibility(
                  visible: (widget.showClearButton && onSelectLabel != null),
                  child: TextButton(
                    //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(Icons.clear),
                    onPressed: () {
                      widget.onChanged!(null);
                      onSelectLabel = null;
                      setState(() {});
                    },
                  )),
              Icon(
                Icons.arrow_drop_down,
                color: widget.items.isEmpty ? Colors.grey : Colors.black,
              )
            ],
          ),
          onPressed: () {
            if (widget.enabled == null || widget.enabled == true) {
              menuData.clear();
              if (widget.items.isNotEmpty) {
                for (int i = 0; i < widget.dropDownMenuItems!.length; i++) {
                  menuData.add(widget.dropDownMenuItems![i].toString() +
                      '-_-' +
                      i.toString());
                }
                mainDataListGroup = menuData;
                newDataList = mainDataListGroup;
                searchC.clear();
                if (widget.menuMode == true) {
                  if (isMenuOpen) {
                    closeMenu();
                  } else {
                    openMenu();
                  }
                } else {
                  showDialogueBox(context);
                }
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> showDialogueBox(context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(15),
            child: mainScreen(),
          );
        }).then((valueFromDialog) {
      // use the value as you wish
      setState(() {});
    });
  }

  mainScreen() {
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                  visible: widget.multiSelect,
                  child: Row(
                    children: [
                      TextButton(
                        child: Text(
                          'Select All',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          selectedValues.clear();
                          for (int i = 0; i < newDataList.length; i++) {
                            selectedValues.add(newDataList[i]);
                          }
                          setState(() {});
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedValues.clear();
                          });
                        },
                      ),
                    ],
                  )),
              Visibility(
                visible: widget.hideSearch,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: TextFormField(
                    controller: searchC,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      hintText: 'Search Here...',
                    ),
                    onChanged: (v) {
                      onItemChanged(v);
                      setState(() {});
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: newDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        child: Row(
                          children: [
                            Visibility(
                              visible: widget.multiSelect,
                              child: Checkbox(
                                  value: selectedValues
                                          .contains(newDataList[index])
                                      ? true
                                      : false,
                                  activeColor: Colors.green,
                                  onChanged: (newValue) {
                                    if (selectedValues
                                        .contains(newDataList[index])) {
                                      setState(() {
                                        selectedValues
                                            .remove(newDataList[index]);
                                      });
                                    } else {
                                      setState(() {
                                        selectedValues.add(newDataList[index]);
                                      });
                                    }
                                  }),
                            ),
                            Expanded(
                              child: Text(
                                newDataList[index].split('-_-')[0].toString(),
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (widget.multiSelect) {
                            if (selectedValues.contains(newDataList[index])) {
                              setState(() {
                                selectedValues.remove(newDataList[index]);
                              });
                            } else {
                              setState(() {
                                selectedValues.add(newDataList[index]);
                              });
                            }
                          } else {
                            // print('iiiiiiiiiiiiiiiiiiiii');
                            for (int i = 0; i < menuData.length; i++) {
                              if (menuData[i] == newDataList[index]) {
                                onSelectLabel =
                                    menuData[i].split('-_-')[0].toString();
                                widget.onChanged!(widget.items[i]);
                              }
                            }
                            if (widget.menuMode == true) {
                              closeMenu();
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        },
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      if (widget.menuMode == true) {
                        closeMenu();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Visibility(
                    visible: (widget.multiSelect == true && widget.multiSelect),
                    child: TextButton(
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        var sendList = [];
                        for (int i = 0; i < menuData.length; i++) {
                          if (selectedValues.contains(menuData[i])) {
                            sendList.add(widget.items[i]);
                          }
                        }
                        print(sendList);
                        widget.onChanged!(jsonEncode(sendList));
                        if (widget.menuMode == true) {
                          closeMenu();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
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
