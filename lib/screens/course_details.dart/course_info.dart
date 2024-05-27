import 'package:easy_localization/easy_localization.dart';
import 'package:talimger_mobile/models/app_settings_model.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:talimger_mobile/models/course.dart';
import 'package:talimger_mobile/models/user_model.dart';
import 'package:talimger_mobile/screens/author_profie/author_profile.dart';
import 'package:talimger_mobile/services/app_service.dart';
import 'package:talimger_mobile/services/firebase_service.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import 'package:talimger_mobile/utils/snackbars.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: course.price != null && !isTesting,
            child: Row(
              children: [
                const Icon(FeatherIcons.dollarSign,
                    size: 20, color: Colors.blueGrey),
                const SizedBox(width: 5),
                Expanded(
                    child: Text('${'price'.tr()}: ${course.price ?? ''}₸',
                        style: Theme.of(context).textTheme.bodyLarge)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.calendar,
                  size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Expanded(
                child: Text('last-updated-',
                        style: Theme.of(context).textTheme.bodyLarge)
                    .tr(
                  args: [
                    AppService.getDate(course.updatedAt ?? course.createdAt,
                        locale: context.locale)
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.globe, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text('language-', style: Theme.of(context).textTheme.bodyLarge)
                  .tr(args: [course.courseMeta.language.toString()]),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.clock, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Expanded(
                child: Text('duration-',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyLarge)
                    .tr(
                  args: [
                    course.courseMeta.duration.toString(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.book, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text('count-lesson', style: Theme.of(context).textTheme.bodyLarge)
                  .tr(args: [course.lessonsCount.toString()]),
            ],
          ),
        ],
      ),
    );
  }

  void _onTapAuthor(BuildContext context) async {
    final UserModel? author =
        await FirebaseService().getAuthorData(course.author.id);
    if (!context.mounted) return;
    if (author != null) {
      NextScreen.popup(context, AuthorProfile(user: author));
    } else {
      openSnackbar(context, 'Error on getting author profile');
    }
  }
}
