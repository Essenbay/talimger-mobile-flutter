import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/components/loading_list_tile.dart';
import 'package:talimger_mobile/configs/app_assets.dart';
import 'package:talimger_mobile/screens/search/search_view.dart';
import 'package:talimger_mobile/utils/empty_animation.dart';

import '../../components/course_tile.dart';

class SearchedCourses extends ConsumerWidget {
  const SearchedCourses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couesesProvider = ref.watch(searchedCoursesProvider);
    return couesesProvider.when(
      loading: () => const LoadingListTile(height: 160),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      data: (courses) {
        if (courses.isEmpty) {
          return EmptyAnimation(
              animationString: emptyAnimation, title: 'no-course'.tr());
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: courses
                .map((e) => Column(
                      children: [
                        CourseTile(course: e),
                        const Divider(height: 20),
                      ],
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
