import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:flutter/material.dart';

class AppBarSteps extends StatelessWidget {
  final int totalSteps;
  final int currStep;

  const AppBarSteps({
    Key? key,
    required this.totalSteps,
    required this.currStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dummyList = [for (var i = 1; i <= totalSteps; i++) i];
    double width = MediaQuery.of(context).size.width;
    width /= 3;
    width -= 25 * (totalSteps - 1);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: dummyList
            .map((e) => e == currStep
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      width: width,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      width: 25,
                      height: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ))
            .toList(),
      ),
    );
  }
}
