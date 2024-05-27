import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/screens/video_player_screen.dart';
import '../components/mark_complete_button.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class VideoLesson extends ConsumerStatefulWidget {
  const VideoLesson({super.key, required this.course, required this.lesson});

  final Course course;
  final Lesson lesson;

  @override
  ConsumerState<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends ConsumerState<VideoLesson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayerScreen(videoUrl: widget.lesson.videoUrl.toString()),
          Align(
            alignment: Alignment.bottomCenter,
            // Visible after 1 sec for video loading time
            child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return MarkCompleteButton(
                      course: widget.course, lesson: widget.lesson);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
