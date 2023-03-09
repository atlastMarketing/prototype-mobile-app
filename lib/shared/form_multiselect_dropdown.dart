import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormMultiselectDropdown extends StatefulWidget {
  final String placeholder;
  final List<String> listOfOptions;
  final List<String> listOfSelectedOptions;
  final void Function(List<String>) setListOfSelectedOptions;
  final bool hasError;
  final String validationMsg;

  const CustomFormMultiselectDropdown({
    Key? key,
    this.placeholder = "Select options",
    required this.listOfOptions,
    required this.listOfSelectedOptions,
    required this.setListOfSelectedOptions,
    this.hasError = false,
    this.validationMsg = "",
  }) : super(key: key);

  @override
  _CustomFormMultiselectDropdownState createState() =>
      _CustomFormMultiselectDropdownState();
}

class _CustomFormMultiselectDropdownState
    extends State<CustomFormMultiselectDropdown> {
  String selectedText = "";

  @override
  Widget build(BuildContext context) {
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
              title: Text(widget.listOfSelectedOptions.isEmpty
                  ? widget.placeholder
                  : widget.listOfSelectedOptions.join(", ")),
              children: <Widget>[
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.listOfOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: _ViewItem(
                        item: widget.listOfOptions[index],
                        selected: (val) {
                          selectedText = val;
                          List<String> newListOfSelectedOptions =
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
                            .contains(widget.listOfOptions[index]),
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
  String item;
  bool itemSelected;
  final Function(String) selected;

  _ViewItem({
    required this.item,
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
                selected(item);
              },
            ),
          ),
          SizedBox(width: size.width * .025),
          Text(item),
        ],
      ),
    );
  }
}
