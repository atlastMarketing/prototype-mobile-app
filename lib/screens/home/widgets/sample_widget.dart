import 'package:flutter/material.dart';

class SampleWidget extends StatelessWidget {
  final String data;
  const SampleWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Hello, here is some data: $data'));
  }
}
