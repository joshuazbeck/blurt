import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/api.dart';
import '../../models/blurt.dart';
import 'dart:math';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = PageController(viewportFraction: 0.4, keepPage: true);
  Iterable<Blurt> _blurts = [];
  Random random = Random();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getBlurts();
      setState(() {});
    });
    super.initState();
  }

  Future<void> getBlurts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    API api = API();
    api.getBlurts().then((value) {
      setState(() {
        _blurts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        _blurts.length,
        (index) => _blurts.elementAt(index) != null
            ? BlurtRow(
                expanded: random.nextBool(), blurt: _blurts.elementAt(index))
            : Center(child: const CircularProgressIndicator()));

    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          SizedBox(height: 16),
          (pages.length > 0)
              ? SizedBox(
                  height: 500,
                  child: PageView.builder(
                    controller: controller,
                    // itemCount: pages.length,
                    itemBuilder: (_, index) {
                      if (pages.length > 0) {
                        return pages[index % pages.length];
                      } else
                        return null;
                    },
                    scrollDirection: Axis.vertical,
                  ),
                )
              : Center(child: const CircularProgressIndicator()),
          SmoothPageIndicator(
            controller: controller,
            count: pages.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 16,
              dotWidth: 16,
            ),
          ),
        ]));
  }
}

class BlurtRow extends StatefulWidget {
  final bool expanded;
  final Blurt blurt;
  const BlurtRow({super.key, required this.expanded, required this.blurt});

  @override
  State<BlurtRow> createState() => _BlurtRowState();
}

class _BlurtRowState extends State<BlurtRow> {
  @override
  Widget build(BuildContext context) {
    return widget.expanded
        ? Container(
            child: Text(
            widget.blurt.title,
            style: Theme.of(context).textTheme.bodyLarge,
          ))
        : Expanded(
            child: Row(
            children: [
              Padding(
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(widget.blurt.friend.imageUrl)),
                  ],
                ),
                padding: EdgeInsets.only(top: 30.0),
              ),
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(widget.blurt.friend.name),
                      Spacer(),
                      Text("${widget.blurt.length.toString()} sec"),
                    ],
                  )),
                  Row(children: [
                    Expanded(
                        child: Text(
                      widget.blurt.title,
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                    )),
                  ]),
                  Expanded(
                      child: Row(
                    children: [
                      Text("PLAY"),
                      Spacer(),
                      Text("iIIii.i...iIIi.i")
                    ],
                  ))
                ],
              ))
            ],
          ));
  }
}
