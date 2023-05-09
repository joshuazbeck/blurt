import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:blurt/screens/templates/template.dart';
import 'package:blurt/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

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

/// The feed for the app (the dashboard)
class _DashboardState extends State<Dashboard> {
  /// The controller responsible for paging
  final controller = PageController(
    viewportFraction: 0.4,
    keepPage: true,
  );

  /// Hold a list of blurts
  Iterable<Blurt> _blurts = [];

  /// Build a random number generator
  Random random = Random();

  /// Initialize the page
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the blurts
      getBlurts();

      // Refresh state
      setState(() {});
    });

    super.initState();
  }

  /// Get the available blurts from the API service
  Future<void> getBlurts() async {
    // Create an instance of the API
    API api = API();

    // Create a new instance of the authentication service
    AuthService authService = AuthService();

    // Get the authenticated users
    authService.getAuthenticatedUser().then((value) {
      // If the user is logged in
      if (value != null && value.username != null) {
        // Get the blurts for the user
        api.getBlurts(value.username!).then((value) {
          setState(() {
            _blurts = value;
          });
        });
      }
    });
  }

  /// Build the form for the dashboard
  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        _blurts.length,
        (index) => _blurts.elementAt(index) != null
            ? BlurtRow(expanded: false, blurt: _blurts.elementAt(index))
            : const Center(child: CircularProgressIndicator()));

    return Template(
      bottomButton: IconButton(
        icon: const Icon(Icons.mic),
        onPressed: () {
          _openRecorder(context);
        },
        color: Colors.white,
        iconSize: 40,
      ),
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
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      const SizedBox(height: 16),
                      (pages.isNotEmpty)
                          ? SizedBox(
                              height: 720,
                              child: PageView.builder(
                                controller: controller,
                                itemBuilder: (_, index) {
                                  if (pages.isNotEmpty) {
                                    return pages[index % pages.length];
                                  } else {
                                    return null;
                                  }
                                },
                                scrollDirection: Axis.vertical,
                                itemCount: pages.length,
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      IconButton(
                          icon: const Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 50,
                          onPressed: () async {
                            //TODO: Implement method
                          }),
                    ]))))
      ]),
    );
  }

  // Open the recorder
  void _openRecorder(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Record())),
    );
  }
}

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
          Text(widget.blurt.friend.getName(),
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
