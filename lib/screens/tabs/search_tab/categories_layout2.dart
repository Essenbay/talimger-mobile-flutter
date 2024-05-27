import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/screens/all_courses.dart/courses_view.dart';
import 'package:talimger_mobile/utils/custom_cached_image.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import '../../../models/category.dart';

class CategoriesLayout2 extends StatelessWidget {
  const CategoriesLayout2({
    super.key,
    required this.categories,
  });

  final AsyncValue<List<Category>> categories;

  @override
  Widget build(BuildContext context) {
    return categories.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('error: $error'),
      data: (data) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'all-categories',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ).tr(),
              ...data.map(
                (category) => ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  title: Text(category.name),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  trailing: const Icon(FeatherIcons.chevronRight),
                  leading: SizedBox(
                    height: 40,
                    width: 50,
                    child: CustomCacheImage(
                      imageUrl: category.thumbnailUrl,
                      radius: 3,
                    ),
                  ),
                  onTap: () => NextScreen.iOS(
                      context,
                      AllCoursesView(
                        courseBy: CourseBy.category,
                        title: category.name,
                        categoryId: category.id,
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
