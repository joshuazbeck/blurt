import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:blurt/view/templates/template_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../assets/style/theme.dart';
import '../../controllers/auth_service.dart';
import '../../controllers/friend_service.dart';
import '../../main.dart';
import '../../model/items/blurt.dart';
import '../../model/items/friend.dart';
import '../main/dashboard.dart';
import '../templates/template.dart';
import '../../controllers/blurt_service.dart';

/// Widget to add a title to a new recorded blurt
class RecordTitle extends StatefulWidget {
  double length;
  RecordTitle({super.key, required this.length});

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
  String _recordTitle = "";
  int _maxLength = 100;

  /// Controller for holding the player
  PlayerController controller = PlayerController();

  Future<void> initPlayer() async {
    var blurtService = BlurtService();
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
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplateForm(
      bottomButton: IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {
          _saveBlurt(context);
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
              decoration: InputDecoration(
                  hintText: "your blurt\'s title",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixText: '${_recordTitle.length}/${_maxLength}',
                  suffixStyle: Theme.of(context).textTheme.bodySmall,
                  counterText: "",
                  fillColor: Colors.black),
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.text,
              maxLines: null,
              autofocus: true,
              maxLength: _maxLength,
              onChanged: (value) {
                setState(() {
                  _recordTitle = value;
                });
              },
              style: Theme.of(context).textTheme.bodyLarge,
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 10),
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
          ]),
    );
  }

  /// Pause or play the audio
  void _pauseOrPlay() async {
    // Pause the recording
    if (_playing == true) {
      if (mounted) {
        setState(() {
          _playIcon = const Icon(Icons.play_arrow);
          _playing = false;
        });
      }
      await controller.pausePlayer();
    } else {
      // Start recording
      if (mounted) {
        setState(() {
          _playIcon = const Icon(Icons.pause_outlined);
          _playing = true;
        });
      }
      await controller.startPlayer(finishMode: FinishMode.pause);
      controller.onCompletion.listen((event) {
        // At the end of the recording, show the replay button
        if (mounted) {
          setState(() {
            _playIcon = const Icon(Icons.replay_outlined);
            _playing = false;
          });
        }
      });
    }
  }

  void _saveBlurt(BuildContext context) async {
    // Save the blurt

    BlurtService bS = new BlurtService();
    AuthService aS = new AuthService();
    FullUser? fullUser = await aS.getAuthenticatedUser();

    //TODO: Impelment an actual audio and image path
    if (fullUser?.username != null) {
      const audioPath = "";
      var length = widget.length;
      var title = _recordTitle;
      Blurt b = Blurt(null, audioPath, title, length);
      await bS.addBlurt(fullUser!.username!, b);
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Main(page: const Dashboard())),
      (Route<dynamic> route) => false,
    );
  }
}
