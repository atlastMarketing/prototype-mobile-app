import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormMultiselectDropdown extends StatefulWidget {
  final String placeholder;
  final Map<dynamic, String> listOfOptions;
  final List<dynamic> listOfSelectedOptions;
  final void Function(List<dynamic>) setListOfSelectedOptions;
  final bool hasError;
  final String validationMsg;
  final FocusNode? focusNode;

  const CustomFormMultiselectDropdown({
    Key? key,
    this.placeholder = "Select options",
    required this.listOfOptions,
    required this.listOfSelectedOptions,
    required this.setListOfSelectedOptions,
    this.hasError = false,
    this.validationMsg = "",
    this.focusNode,
  }) : super(key: key);

  @override
  _CustomFormMultiselectDropdownState createState() =>
      _CustomFormMultiselectDropdownState();
}

class _CustomFormMultiselectDropdownState
    extends State<CustomFormMultiselectDropdown> {
  @override
  Widget build(BuildContext context) {
    List<String> listOfSelectedOptionsString = widget.listOfSelectedOptions
        .map((e) => widget.listOfOptions[e]!)
        .toList();
    List<dynamic> listOfOptionsKeys = widget.listOfOptions.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.dark),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: ExpansionTile(
              iconColor: AppColors.dark,
              title: Text(listOfSelectedOptionsString.isEmpty
                  ? widget.placeholder
                  : listOfSelectedOptionsString.join(", ")),
              children: <Widget>[
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.listOfOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: _ViewItem(
                        value: listOfOptionsKeys[index],
                        display:
                            widget.listOfOptions[listOfOptionsKeys[index]]!,
                        selected: (val) {
                          List<dynamic> newListOfSelectedOptions =
                              widget.listOfSelectedOptions;
                          if (widget.listOfSelectedOptions.contains(val)) {
                            newListOfSelectedOptions.remove(val);
                          } else {
                            newListOfSelectedOptions.add(val);
                          }
                          widget.setListOfSelectedOptions(
                              newListOfSelectedOptions);
                        },
                        itemSelected: widget.listOfSelectedOptions
                            .contains(listOfOptionsKeys[index]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        widget.hasError
            ? Text(
                widget.validationMsg,
                style: const TextStyle(color: AppColors.error),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}

class _ViewItem extends StatelessWidget {
  dynamic value;
  String display;
  bool itemSelected;
  final Function(dynamic) selected;

  _ViewItem({
    required this.value,
    required this.display,
    required this.itemSelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * .032, right: size.width * .098),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
              value: itemSelected,
              onChanged: (val) {
                selected(value);
              },
            ),
          ),
          SizedBox(width: size.width * .025),
          Text(display),
        ],
      ),
    );
  }
}
