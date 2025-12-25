import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class DokterSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  DokterSliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 16; // Added padding
  @override
  double get maxExtent => tabBar.preferredSize.height + 16;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(DokterSliverAppBarDelegate oldDelegate) {
    return false;
  }
}
