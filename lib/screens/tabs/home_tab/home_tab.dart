import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/components/app_logo.dart';
import 'package:talimger_mobile/configs/app_config.dart';
import 'package:talimger_mobile/screens/tabs/home_tab/top_authors.dart';
import 'package:talimger_mobile/screens/search/search_view.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import '../../../providers/app_settings_provider.dart';
import 'category1_courses.dart';
import 'category2_courses.dart';
import 'category3_courses.dart';
import 'featured_courses.dart';
import 'free_courses.dart';
import 'home_categories.dart';
import 'home_latest_courses.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    return RefreshIndicator.adaptive(
      displacement: 60,
      onRefresh: () async {
        ref.invalidate(featuredCoursesProvider);
        ref.invalidate(homeCategoriesProvider);
        ref.invalidate(freeCoursesProvider);
        ref.invalidate(category1CoursessProvider);
        ref.invalidate(category2CoursessProvider);
        ref.invalidate(category3CoursessProvider);
        ref.invalidate(topAuthorsProvider);
        ref.invalidate(homeLatestCoursesProvider);
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppConfig.appbarColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const AppLogo(),
                  Text(
                    AppConfig.appName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            leadingWidth: 200,
            pinned: false,
            floating: true,
            elevation: 0,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  NextScreen.iOS(context, const SearchScreen());
                },
                icon: const Icon(FeatherIcons.search, size: 22),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Visibility(
                    visible: settings?.featured ?? true,
                    child: const FeaturedCourses()),
                Visibility(
                    visible: settings?.categories ?? true,
                    child: const HomeCategories()),
                Visibility(
                    visible: settings?.freeCourses ?? true,
                    child: const FreeCourses()),
                if (settings != null && settings.homeCategory1 != null)
                  Category1Courses(category: settings.homeCategory1!),
                if (settings != null && settings.homeCategory2 != null)
                  Category2Courses(category: settings.homeCategory2!),
                if (settings != null && settings.homeCategory3 != null)
                  Category3Courses(category: settings.homeCategory3!),
                Visibility(
                    visible: settings?.topAuthors ?? true,
                    child: const TopAuthors()),
                Visibility(
                    visible: settings?.latestCourses ?? true,
                    child: const HomeLatestCourses()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
