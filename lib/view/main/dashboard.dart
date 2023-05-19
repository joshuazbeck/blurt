import 'package:blurt/view/templates/template.dart';
import 'package:flutter/material.dart';

import '../../assets/style/theme.dart';
import '../../main.dart';

import '../record/record.dart';
import 'feed.dart';
import 'mine.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _i = 1;
  final _mineI = 1;
  final _feedI = 2;

  Widget getPage(i) {
    if (i == _feedI) {
      return const Feed();
    } else {
      return const Mine();
    }
  }

  // Open the recorder
  void _openRecorder(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Record())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Template(
        bottomButton: IconButton(
          icon: const Icon(Icons.mic),
          onPressed: () {
            _openRecorder(context);
          },
          color: BlurtTheme.white,
          iconSize: 40,
        ),
        child: Row(children: [
          // Return the correct friend sub page
          Expanded(
            child: getPage(_i),
          ),
          Column(
            children: [
              const Spacer(),
              RotatedBox(
                  quarterTurns: 5,
                  child: Row(children: [
                    // Hold links to the different pages
                    TextButton(
                      child: Text("MINE",
                          style: (_i == _mineI)
                              ? TextStyle(
                                  height: 1.5,
                                  shadows: [
                                    //Hack to move the underlines away from the text
                                    Shadow(
                                        color: Theme.of(context).primaryColor,
                                        offset: const Offset(0, -3))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                )
                              : TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                      onPressed: () {
                        //Open the "CURRENT" friend page
                        setState(() {
                          _i = _mineI;
                        });
                      },
                    ),
                    TextButton(
                      child: Text("FEED",
                          style: (_i == _feedI)
                              ? TextStyle(
                                  height: 1.5,
                                  shadows: [
                                    // Hack to move the underlines away from the text
                                    Shadow(
                                        color: Theme.of(context).primaryColor,
                                        offset: const Offset(0, -3))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                )
                              : TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                      onPressed: () {
                        setState(() {
                          _i = _feedI;
                        });
                      },
                    ),
                  ])),
              const Spacer()
            ],
          )
        ]));
  }
}
