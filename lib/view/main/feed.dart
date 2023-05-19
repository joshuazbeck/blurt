import 'package:blurt/controllers/blurt_service.dart';
import 'package:blurt/controllers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/items/blurt.dart';
import 'dart:math';
import 'blurt_row.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

/// The feed for the app (the dashboard)
class _FeedState extends State<Feed> {
  /// The controller responsible for paging
  final controller = PageController(
    viewportFraction: 0.4,
    keepPage: true,
  );

  /// Hold a list of blurts
  Iterable<Blurt> _blurts = [];

  bool _hasFriends = true;

  /// Build a random number generator
  Random random = Random();
  final _scrollController = ScrollController();

  /// Initialize the page
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        print(_scrollController.position.pixels);
      }
    });
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
    // API api = API();
    BlurtService bS = BlurtService();
    // Create a new instance of the authentication service
    AuthService authService = AuthService();

    // Get the authenticated users
    authService.getAuthenticatedUser().then((value) async {
      // If the user is logged in
      if (value != null && value.username != null) {
        // Get the blurts for the user
        List<Blurt>? b = await bS.getBlurts(value.username!);
        setState(() => {
              if (b != null) {_blurts = b}
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
            ? Column(children: [
                BlurtRow(expanded: false, blurt: _blurts.elementAt(index)),
              ])
            : const Center(child: CircularProgressIndicator()));

    return (_blurts.isNotEmpty)
        ? Row(children: [
            Container(
                width: 50,
                child: SmoothPageIndicator(
                  controller: controller,
                  count: pages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 16,
                    dotWidth: 16,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                  axisDirection: Axis.vertical,
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(30),
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
            ))
          ])
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()]);
  }
}
