import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:blurt/screens/templates/template_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../main/dashboard.dart';
import '../templates/template.dart';

/// Widget to add a title to a new recorded blurt
class RecordTitle extends StatefulWidget {
  const RecordTitle({super.key});

  @override
  State<RecordTitle> createState() => _RecordTitleState();
}

class _RecordTitleState extends State<RecordTitle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  // Hold the form identifier
  final _formKey = GlobalKey<FormState>();

  // Hold the icon for the record button
  Icon _playIcon = const Icon(Icons.play_arrow);
  bool _playing = false;
  bool _isLoading = true;

  /// Controller for holding the player
  PlayerController controller = PlayerController();

  Future<void> initPlayer() async {
    // Create a temporary directory to store the recorded file
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/temp_audio.wav';

    http.Response response = await http.get(
        Uri.parse('https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav'));
    File file = File(path);
    file.writeAsBytesSync(response.bodyBytes);

    // Prepare the recorder controller
    await controller.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
      noOfSamples: 30,
      volume: 1.0,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplateForm(
      bottomButton: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          _returnToDashboard(context);
        },
        color: Colors.white,
        iconSize: 40,
      ),
      formKey: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.josefinSlab().fontFamily),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 40),
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
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: _pauseOrPlay),
                        Expanded(
                            child: AudioFileWaveforms(
                                size: const Size(100.0, 70.0),
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
                  )
                : const Center(child: CircularProgressIndicator()),
          ]),
    );
  }

  /// Pause or play the audio
  void _pauseOrPlay() async {
    // Pause the recording
    if (_playing == true) {
      setState(() {
        _playIcon = const Icon(Icons.play_arrow);
        _playing = false;
      });

      await controller.pausePlayer();
    } else {
      // Start recording
      setState(() {
        _playIcon = const Icon(Icons.pause_outlined);
        _playing = true;
      });
      await controller.startPlayer(finishMode: FinishMode.pause);
      controller.onCompletion.listen((event) {
        // At the end of the recording, show the replay button
        setState(() {
          _playIcon = const Icon(Icons.replay_outlined);
          _playing = false;
        });
      });
    }
  }

  void _returnToDashboard(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Main(page: const Dashboard())),
    );
  }
}
