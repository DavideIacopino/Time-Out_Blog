import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPress;
  final Color background;
  final Color iconColor;

  const CircularIconButton({Key? key, required this.icon, required this.onPress,
    required this.background, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(fixedSize: Size(10.0, 10.0),primary: background,shape:CircleBorder(),),
        child: Icon(icon, color: iconColor),
      )
    );
  }


}