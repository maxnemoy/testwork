import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final Widget icon;
  final Function onClick;
  final Color borderColor;
  final double width;
  final double height;
  const RectangleButton({ Key? key, required this.icon, required this.onClick, this.borderColor = Colors.black, this.height = 50, this.width = 50 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onClick(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(border: Border.all(color: borderColor)),
        child: Center(child: icon,),
      ),
    );
  }
}