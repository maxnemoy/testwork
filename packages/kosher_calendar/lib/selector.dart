import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final List<SelectorSigment> sigments;
  const Selector(
      {Key? key,
      required this.sigments,
      this.borderColor = Colors.transparent,
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5)),
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: sigments,
        ));
  }
}

class SelectorSigment extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onClick;
  final Color selectedColor;
  final Color selectedTextColor;
  const SelectorSigment(
      {Key? key,
      required this.title,
      required this.isSelected,
      required this.onClick,
      this.selectedColor = Colors.blue,
      this.selectedTextColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onClick(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: isSelected
              ? BoxDecoration(color: selectedColor, borderRadius: BorderRadius.circular(16))
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Text(title,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: isSelected ? selectedTextColor : selectedColor)),
            ),
          ),
        ),
      ),
    );
  }
}
