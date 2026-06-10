library custom_searchable_dropdown;

import 'dart:convert';

import 'package:flutter/material.dart';

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
  final double? menuHeight;
  final EdgeInsetsGeometry? padding;
  final Color? primaryColor;
  final double? searchBarHeight;
  final TextStyle? labelStyle;

  const CustomSearchableDropDown({
    super.key,
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
    this.menuHeight,
    this.padding,
    this.primaryColor,
    this.searchBarHeight,
    this.labelStyle,
  });

  @override
  State<CustomSearchableDropDown<T>> createState() =>
      _CustomSearchableDropDownState<T>();
}

class _CustomSearchableDropDownState<T> extends State<CustomSearchableDropDown<T>> {
  String? onSelectLabel;
  final searchC = TextEditingController();
  List menuData = [];
  List mainDataListGroup = [];
  List newDataList = [];

  List selectedValues = [];

  final GlobalKey _key = LabeledGlobalKey("button_icon");
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
              height: widget.menuHeight ?? 300,
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
            debugPrint(onSelectLabel);
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
        padding: widget.padding ?? const EdgeInsets.all(10.0),
        child: TextButton(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Row(
            children: [
              widget.prefixIcon == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
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
                                      decoration: BoxDecoration(
                                          color: widget.primaryColor ?? Colors.green,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(0.0),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 2, 5, 2),
                                        child: Text(
                                          selectedValues[index]
                                              .split('-_-')[0]
                                              .toString(),
                                          style: const TextStyle(
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
                                      ? "${selectedValues.length} values selected"
                                      : "${selectedValues.length} ${widget.multiSelectTag} selected"
                                  : widget.multiSelectTag == null
                                      ? "${selectedValues.length} values selected"
                                      : "${selectedValues.length} ${widget.multiSelectTag} selected",
                              style: const TextStyle(color: Colors.grey),
                            ))
                  : Expanded(
                      child: Text(
                        onSelectLabel == null
                            ? widget.label == null
                                ? 'Select Value'
                                : widget.label!
                            : onSelectLabel!,
                        style: widget.labelStyle ??
                            TextStyle(
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
                    child: const Icon(Icons.clear),
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
            if (widget.enabled) {
              menuData.clear();
              if (widget.items.isNotEmpty) {
                for (int i = 0; i < widget.dropDownMenuItems!.length; i++) {
                  menuData.add("${widget.dropDownMenuItems![i]}-_-$i");
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
            padding: const EdgeInsets.all(15),
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
                          style: TextStyle(color: widget.primaryColor ?? Colors.blue),
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
                          style: TextStyle(color: widget.primaryColor ?? Colors.blue),
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
                  child: SizedBox(
                    height: widget.searchBarHeight,
                    child: TextFormField(
                      controller: searchC,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: widget.primaryColor ?? Colors.blue,
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
                                  activeColor: widget.primaryColor ?? Colors.green,
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
                        color: widget.primaryColor ?? Colors.blue,
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
                        style: TextStyle(color: widget.primaryColor ?? Colors.blue),
                      ),
                      onPressed: () {
                        var sendList = [];
                        for (int i = 0; i < menuData.length; i++) {
                          if (selectedValues.contains(menuData[i])) {
                            sendList.add(widget.items[i]);
                          }
                        }
                        debugPrint(sendList.toString());
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
