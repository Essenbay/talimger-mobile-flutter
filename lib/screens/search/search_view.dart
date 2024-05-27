import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/models/course.dart';
import 'package:talimger_mobile/screens/search/search_bar.dart';
import 'package:talimger_mobile/screens/search/searched_courses.dart';
import 'package:talimger_mobile/screens/tabs/search_tab/categories_layout2.dart';
import 'package:talimger_mobile/screens/tabs/search_tab/search_tab.dart';
import 'package:talimger_mobile/services/firebase_service.dart';

final searchTextCtlrProvider =
    Provider.autoDispose((ref) => TextEditingController());
final searchStartedProvider = StateProvider.autoDispose<bool>((ref) => false);
final recentSearchDataProvider = StateProvider<List<String>>((ref) => []);

final searchedCoursesProvider =
    FutureProvider.autoDispose<List<Course>>((ref) async {
  final value = ref.watch(searchTextCtlrProvider).text;
  final allCourses = await FirebaseService().getAllCourses();
  final List<Course> filteredCourses = allCourses
      .where((course) =>
          course.name.toLowerCase().contains(value.toLowerCase()) ||
          course.courseMeta.description
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          course.courseMeta.learnings
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          course.courseMeta.summary
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          course.courseMeta.requirements
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
      .toList();

  return filteredCourses;
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFieldCtrl = ref.watch(searchTextCtlrProvider);
    final bool searchStarted = ref.watch(searchStartedProvider);
    final categories = ref.watch(categoriesProvider);

    Widget buildView() {
      if (searchStarted) {
        return const SearchedCourses();
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CategoriesLayout2(categories: categories),
        );
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: SearchAppBar(searchTextCtlr: searchFieldCtrl),
          leading: IconButton(
            icon: const Icon(FeatherIcons.chevronLeft),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: [
            const Divider(height: 5),
            buildView(),
          ],
        ),
      ),
    );
  }
}
