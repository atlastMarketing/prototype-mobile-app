import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'widgets/sample_widget.dart';

class HomeDetails extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const HomeDetails({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  void goBack() {
    navKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
          onPressed: goBack,
          color: AppColors.black,
        ),
        leadingWidth: 60,
        toolbarHeight: 80,
      ),
      body: Center(
        child: Column(
          children: const [
            Text('You are on the home details page'),
            SampleWidget(data: 'Data')
          ],
        ),
      ),
      extendBody: false,
    );
  }
}
