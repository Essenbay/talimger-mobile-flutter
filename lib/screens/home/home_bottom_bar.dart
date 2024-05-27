import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/screens/home/home_view.dart';
import 'package:talimger_mobile/theme/theme_provider.dart';

// Bottom Tabs
const Map<int, List> homeTabs = {
  1: ['home', FeatherIcons.home],
  2: ['wishlist', FeatherIcons.heart],
  3: ['my-courses', FeatherIcons.book],
  4: ['profile', FeatherIcons.user],
};

final navBarIndexProvider = StateProvider<int>((ref) => 0);

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navBarIndexProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(navBarIndexProvider.notifier).state = index;
        if (_shouldAnimate(currentIndex, index)) {
          ref.read(homeTabControllerProvider.notifier).state.animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn);
        } else {
          ref.read(homeTabControllerProvider.notifier).state.jumpToPage(index);
        }
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: isDarkMode
          ? Colors.white.withOpacity(.5)
          : Theme.of(context).primaryColor.withOpacity(.5),
      selectedItemColor:
          isDarkMode ? Colors.white : Theme.of(context).primaryColor,
      items: homeTabs.entries
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e.value[1]),
              label: '',
            ),
          )
          .toList(),
    );
  }

  bool _shouldAnimate(int currentIndex, int newIndex) {
    int dif = currentIndex - newIndex;
    if (dif > 1 || dif < -1) {
      return false;
    } else {
      return true;
    }
  }
}
