import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  Template(
      {super.key,
      required this.child,
      required this.bottomButton,
      this.bottomBarVisible = true});
  final Widget child;
  final Widget bottomButton;
  bool bottomBarVisible = true;
  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        Visibility(
            visible: widget.bottomBarVisible,
            child: Container(
              width: double.infinity,
              height: 75,
              color: Theme.of(context).primaryColor,
              child: widget.bottomButton,
            ))
      ],
    );
  }
}
