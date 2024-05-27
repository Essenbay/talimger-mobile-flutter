import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/models/tag.dart';
import 'package:talimger_mobile/screens/search/search_view.dart';
import 'package:talimger_mobile/services/firebase_service.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import '../../../models/category.dart';
import 'categories_layout2.dart';

final searchTagsProvider = FutureProvider<List<Tag>>((ref) async {
  final tags = await FirebaseService().getAllTags(10);
  return tags;
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final List<Category> categories = await FirebaseService().getAllCategories();
  return categories;
});

class SearchTab extends ConsumerWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 60,
        title: InkWell(
          onTap: () => NextScreen.iOS(context, const SearchScreen()),
          child: Container(
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 0.5),
              borderRadius: BorderRadius.circular(120),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'search-course',
                  style: Theme.of(context).textTheme.bodyLarge,
                ).tr(),
                const Icon(FeatherIcons.search, size: 20),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.invalidate(searchTagsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: CategoriesLayout2(categories: categories),
      ),
    );
  }
}
