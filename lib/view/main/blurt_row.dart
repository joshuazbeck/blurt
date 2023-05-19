import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../assets/style/theme.dart';
import '../../model/items/blurt.dart';

/// Create a row widget for each blurt
class BlurtRow extends StatefulWidget {
  final bool expanded;
  final Blurt blurt;
  const BlurtRow({super.key, required this.expanded, required this.blurt});

  @override
  State<BlurtRow> createState() => _BlurtRowState();
}

class _BlurtRowState extends State<BlurtRow> {
  Icon _playIcon = const Icon(Icons.play_arrow);
  bool _playing = false;
  bool _isLoading = true;
  bool _widgetDisposed = false;
  PlayerController controller = PlayerController();

  ////Initialize the player
  Future<void> initPlayer() async {
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
    super.initState();
    initPlayer();
  }

  /// ******* BUILD THE WIDGET *********
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Row(
        children: [
          Text(widget.blurt.friend?.getName() ?? "",
              style: Theme.of(context).textTheme.bodySmall),
          const Spacer(),
          Text("${widget.blurt.length} sec",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Row(children: [
        Flexible(
            child: Text(widget.blurt.title,
                style: Theme.of(context).textTheme.bodyLarge)),
      ]),
      const SizedBox(
        height: 19,
      ),
      (!_isLoading)
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                children: [
                  IconButton(
                      icon: _playIcon,
                      color: BlurtTheme.white,
                      iconSize: 30,
                      onPressed: _pauseOrPlay),
                  Expanded(
                      child: AudioFileWaveforms(
                          size: const Size(100.0, 70.0),
                          enableSeekGesture: true,
                          playerWaveStyle: const PlayerWaveStyle(
                              liveWaveColor: BlurtTheme.white,
                              fixedWaveColor: BlurtTheme.whiteLight,
                              showSeekLine: false,
                              waveThickness: 6,
                              spacing: 9,
                              scaleFactor: 150.0,
                              waveCap: StrokeCap.round),
                          playerController: controller))
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      const SizedBox(
        height: 20,
      ),
    ]));
  }

  void _pauseOrPlay() async {
    if (_playing == true) {
      setState(() {
        _playIcon = const Icon(Icons.play_arrow);
        _playing = false;
      });

      await controller.pausePlayer();
    } else {
      setState(() {
        _playIcon = const Icon(Icons.pause_outlined);
        _playing = true;
      });
      await controller.startPlayer(finishMode: FinishMode.pause);
      controller.onCompletion.listen((event) {
        setState(() {
          _playIcon = const Icon(Icons.replay_outlined);
          _playing = false;
        });
      });
    }
  }
}
