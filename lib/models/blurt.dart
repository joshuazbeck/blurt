import 'enums.dart';
import 'friend.dart';

/**
 * Holds information for an individual blurt
 */
class Blurt {
  final Friend friend;
  //TODO: Currently linked to static local file
  final String audioPath;
  final String title;
  final double length;

  Blurt(this.friend, this.audioPath, this.title, this.length);
}
