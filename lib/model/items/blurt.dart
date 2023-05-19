import 'enums.dart';
import 'friend.dart';

/// Create a blurt boject
class Blurt {
  final Friend? friend;
  final String audioPath;
  final String title;
  final double length;

  Blurt(this.friend, this.audioPath, this.title, this.length);
}
