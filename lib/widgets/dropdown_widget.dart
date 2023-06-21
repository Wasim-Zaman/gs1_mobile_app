import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  String value;
  List<String> list;
  final double? width;
  final Function? onChanged;

  DropdownWidget({
    super.key,
    required this.value,
    required this.list,
    this.width,
    this.onChanged,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField(
        // Initial Value
        value: widget.value,
        isDense: true,
        isExpanded: true,
        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: widget.list.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: widget.onChanged as void Function(String?)?,
      ),
    );
  }
}
