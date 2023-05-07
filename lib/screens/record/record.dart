import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:blurt/screens/record/record_title.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../templates/template.dart';

class Record extends StatefulWidget {
  const Record({super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  bool _recorderLocked = false;
  final int _allowedDurationLength = 20;
  String _recordPath = "/hi";
  String _elapsedDuration = "0.0 sec";
  String _remainingDuration = "0.0 sec";
  @override
  void initState() {
    // TODO: implement initState
    _initRecordController();

    super.initState();
    recorderController.record();
    recorderController.onCurrentDuration.listen((duration) {
      double seconds = duration.inMilliseconds / 1000;
      double timeRemaining =
          (_allowedDurationLength - (duration.inMilliseconds / 1000));
      if (seconds >= _allowedDurationLength) {
        recorderController.stop();
        _recorderLocked = true;
      }
      setState(() {
        _remainingDuration =
            "${timeRemaining.toStringAsFixed(1)} sec remaining";
        _elapsedDuration = "${seconds.toStringAsFixed(1)} sec";
      });
    });
  }

  bool _isRecording = false;
  late final RecorderController recorderController;

  void _initRecordController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  Widget build(BuildContext context) {
    return Template(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(children: [
                            Flexible(
                                child: AudioWaveforms(
                              enableGesture: true,
                              size: Size(
                                  MediaQuery.of(context).size.width / 1.2, 50),
                              recorderController: recorderController,
                              waveStyle: const WaveStyle(
                                waveColor: Colors.white,
                                extendWaveform: true,
                                showMiddleLine: false,
                              ),
                              padding: const EdgeInsets.only(left: 18),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                            )),
                            Text(_elapsedDuration,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.white))
                          ])))),
              SizedBox(
                height: 20,
              ),
              Opacity(
                  opacity: 0.5,
                  child: Text(_remainingDuration,
                      style: Theme.of(context).textTheme.bodyLarge)),
            ]),
      ),
      bottomButton: IconButton(
        icon: Icon(Icons.fiber_manual_record),
        onPressed: () {
          _openTitle(context);
        },
        color: Colors.white,
        iconSize: 40,
      ),
    );
  }
    void _openTitle(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              MainAuth(page: RecordTitle())),
    );
  }
}
