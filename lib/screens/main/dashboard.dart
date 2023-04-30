import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:blurt/screens/templates/template.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
    _initRecordController();
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
            ? BlurtRow(expanded: false, blurt: _blurts.elementAt(index))
            : Center(child: const CircularProgressIndicator()));

    return Template(
      child: (_isRecording)
          ? Center(
              child: AudioWaveforms(
                enableGesture: true,
                size: Size(MediaQuery.of(context).size.width / 1.2, 50),
                recorderController: recorderController,
                waveStyle: const WaveStyle(
                  waveColor: Colors.white,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.only(left: 18),
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),
            )
          : Row(children: [
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
                                    ),
                                  )
                                : Center(
                                    child: const CircularProgressIndicator()),
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
        icon: _isRecording ? Icon(Icons.fiber_manual_record) : Icon(Icons.mic),
        onPressed: _startStopRecording,
        color: Colors.white,
        iconSize: 40,
      ),
    );
  }

  bool _isRecording = false;
  late final RecorderController recorderController;
  String _recordPath = "/hi";
  void _startStopRecording() async {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
      });
      await recorderController.stop();
    } else {
      setState(() {
        _isRecording = true;
      });
      await recorderController.record();
    }
  }

  void _initRecordController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
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
        child: Column(children: [
      Row(
        children: [
          Text(widget.blurt.friend.name,
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
