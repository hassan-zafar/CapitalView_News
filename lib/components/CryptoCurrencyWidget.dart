import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CryptoCurrencyWidget extends StatelessWidget {
  final String? image;
  final String? price;
  final String? change;
  final Color? color;

  CryptoCurrencyWidget({this.image, this.price, this.change, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: appStore.isDarkMode ? black : white,
        boxShadow: [BoxShadow(color: Colors.black26)],
        border: Border.all(color: appStore.isDarkMode ? Colors.white12 : gainsBoro),
        borderRadius: radius(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image!, width: 40, height: 40),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('\$$price', style: primaryTextStyle(size: 18)).fit(),
              Text('$change%', style: boldTextStyle(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}
