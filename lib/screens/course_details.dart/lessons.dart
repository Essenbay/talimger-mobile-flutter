import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/models/app_settings_model.dart';
import 'package:line_icons/line_icons.dart';
import 'package:talimger_mobile/mixins/course_mixin.dart';
import 'package:talimger_mobile/mixins/user_mixin.dart';
import 'package:talimger_mobile/models/course.dart';
import 'package:talimger_mobile/models/user_model.dart';
import 'package:talimger_mobile/screens/article_lesson.dart';
import 'package:talimger_mobile/screens/auth/login.dart';
import 'package:talimger_mobile/screens/quiz_lesson/quiz_screen.dart';
import 'package:talimger_mobile/screens/video_lesson.dart';
import 'package:talimger_mobile/services/firebase_service.dart';
import 'package:talimger_mobile/utils/loading_widget.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import 'package:talimger_mobile/utils/snackbars.dart';

import '../../models/lesson.dart';
import '../../providers/user_data_provider.dart';

class Lessons extends ConsumerWidget with CourseMixin, UserMixin {
  const Lessons({super.key, required this.course, required this.sectionId});

  final Course course;
  final String sectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    return FutureBuilder(
      future: FirebaseService().getLessons(course.id, sectionId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicatorWidget();
        }
        List<Lesson> lessons = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 0, bottom: 20),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final Lesson lesson = lessons[index];
            return ListTile(
                onTap: () => _onTap(context, lesson, course, user, ref),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                horizontalTitleGap: 10,
                title: Text(
                  lesson.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                subtitle: Text(lesson.contentType).tr(),
                leading: Text(
                  '${index + 1}.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                trailing: _trailingIcon(lesson, user));
          },
        );
      },
    );
  }

  void _onTap(BuildContext context, Lesson lesson, Course course,
      UserModel? user, WidgetRef ref) {
    if (user != null) {
      if (isTesting) {
        _openLesson(context, lesson, ref);
      }
      if (course.price == null) {
        // Free
        if (hasEnrolled(user, course)) {
          _openLesson(context, lesson, ref);
        } else {
          openSnackbar(context, 'entoll_to-open-lesson'.tr());
        }
      } else {
        // Premium
        if (hasEnrolled(user, course) && !UserMixin.isExpired(user)) {
          _openLesson(context, lesson, ref);
        } else {
          openSnackbar(context, 'entoll_to-open-lesson'.tr());
        }
      }
    } else {
      NextScreen.openBottomSheet(context, const LoginScreen());
    }
  }

  void _openLesson(BuildContext context, Lesson lesson, WidgetRef ref) {
    if (lesson.contentType == 'video' && lesson.videoUrl != null) {
      NextScreen.iOS(context, VideoLesson(course: course, lesson: lesson));
    } else if (lesson.contentType == 'article') {
      NextScreen.iOS(context, ArticleLesson(lesson: lesson, course: course));
    } else {
      NextScreen.popup(context, QuizLesson(course: course, lesson: lesson));
    }
  }

  Icon _trailingIcon(Lesson lesson, UserModel? user) {
    if (isLessonCompleted(lesson, user)) {
      return const Icon(Icons.check_box, color: Colors.orange);
    } else {
      if (lesson.contentType == 'video') {
        return const Icon(FeatherIcons.playCircle);
      } else if (lesson.contentType == 'article') {
        return const Icon(LineIcons.stickyNote);
      } else {
        return const Icon(LineIcons.lightbulb);
      }
    }
  }
}
