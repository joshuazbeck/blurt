import 'package:flutter/material.dart';

class TemplateForm extends StatefulWidget {
  TemplateForm(
      {super.key,
      required this.formKey,
      required this.child,
      required this.bottomButton,
      this.bottomBarVisible = true});
  final GlobalKey<FormState> formKey;
  final Widget child;
  final Widget bottomButton;
  bool bottomBarVisible = true;
  @override
  State<TemplateForm> createState() => _TemplateFormState();
}

class _TemplateFormState extends State<TemplateForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: widget.child)),
          Visibility(
              visible: widget.bottomBarVisible,
              child: Container(
                width: double.infinity,
                height: 75,
                color: Theme.of(context).primaryColor,
                child: widget.bottomButton,
              ))
        ]));
  }
}
