import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:blurt/screens/templates/template.dart';
import 'package:blurt/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../data/api.dart';
import '../../main.dart';
import '../../models/blurt.dart';
import 'dart:math';

import '../record/record.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = PageController(
    viewportFraction: 0.4,
    keepPage: true,
  );
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
    AuthService authService = new AuthService();
    authService.getAuthenticatedUser().then((value) {
      if (value != null && value.username != null) {
        api.getBlurts(value.username!).then((value) {
          setState(() {
            _blurts = value;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        _blurts.length,
        (index) => _blurts.elementAt(index) != null
            ? BlurtRow(expanded: false, blurt: _blurts.elementAt(index))
            : Center(child: const CircularProgressIndicator()));

    return Template(
      child: Row(children: [
        Container(
            width: 50,
            child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 16,
                dotWidth: 16,
                activeDotColor: Colors.red,
              ),
              axisDirection: Axis.vertical,
            )),
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                      SizedBox(height: 16),
                      (pages.length > 0)
                          ? SizedBox(
                              height: 720,
                              child: PageView.builder(
                                controller: controller,
                                itemBuilder: (_, index) {
                                  if (pages.length > 0) {
                                    return pages[index % pages.length];
                                  } else
                                    return null;
                                },
                                scrollDirection: Axis.vertical,
                                itemCount: pages.length,
                              ),
                            )
                          : Center(child: const CircularProgressIndicator()),
                      IconButton(
                          icon: Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 50,
                          onPressed: () async {
// Extract waveform data
                            // await controller.startPlayer(finishMode: FinishMode.stop);
                          }),
                    ])))))
      ]),
      bottomButton: IconButton(
        icon: Icon(Icons.mic),
        onPressed: () {
          _openRecorder(context);
        },
        color: Colors.white,
        iconSize: 40,
      ),
    );
  }

  void _openRecorder(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Record())),
    );
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
  Icon _playIcon = Icon(Icons.play_arrow);
  bool _playing = false;
  bool _isLoading = true;
  bool _widgetDisposed = false;
  PlayerController controller = PlayerController();

  Future<void> initPlayer() async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    // print(appDocPath);

    // String path = appDocPath + '/PinkPanther60.wav';
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/temp_audio.wav';

    http.Response response = await http.get(
        Uri.parse('https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav'));
    File file = File(path);
    file.writeAsBytesSync(response.bodyBytes);

    // Directory externalDir = await getExternalStorageDirectory();
    // String dirPath = externalDir.path;

    await controller.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
      noOfSamples: 30,
      volume: 1.0,
    );
    if (!_widgetDisposed) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _widgetDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("josh"),
        child: Column(children: [
          Row(
            children: [
              Text(widget.blurt.friend.getName(),
                  style: Theme.of(context).textTheme.bodySmall),
              Spacer(),
              Text("${widget.blurt.length} sec",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(children: [
            Flexible(
                child: Text(widget.blurt.title,
                    style: Theme.of(context).textTheme.bodyLarge)),
          ]),
          SizedBox(
            height: 19,
          ),
          (!_isLoading)
              ? Container(
                  child: Row(
                    children: [
                      IconButton(
                          icon: _playIcon,
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: _pauseOrPlay),
                      Expanded(
                          child: AudioFileWaveforms(
                              size: Size(100.0, 70.0),
                              enableSeekGesture: true,
                              playerWaveStyle: const PlayerWaveStyle(
                                  liveWaveColor: Colors.white,
                                  fixedWaveColor: Colors.white24,
                                  showSeekLine: false,
                                  waveThickness: 6,
                                  spacing: 9,
                                  scaleFactor: 150.0,
                                  waveCap: StrokeCap.round),
                              playerController: controller))
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          SizedBox(
            height: 20,
          ),
        ]));
  }

  void _pauseOrPlay() async {
    if (_playing == true) {
      setState(() {
        _playIcon = Icon(Icons.play_arrow);
        _playing = false;
      });

      await controller.pausePlayer();
    } else {
      setState(() {
        _playIcon = Icon(Icons.pause_outlined);
        _playing = true;
      });
      await controller.startPlayer(finishMode: FinishMode.pause);
      controller.onCompletion.listen((event) {
        setState(() {
          _playIcon = Icon(Icons.replay_outlined);
          _playing = false;
        });
      });
    }
  }
}
