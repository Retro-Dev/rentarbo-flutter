
import 'package:flutter/material.dart';

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({required this.tabBar, required this.decoration, this.leftRightPadding = 0});

  final TabBar tabBar;
  final BoxDecoration decoration;
  final double leftRightPadding;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned.fill(child: Container(decoration: decoration),left: 20,right: 20,),

        Positioned.fill(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: leftRightPadding),
          child: Container(decoration: decoration),
        )),

        tabBar,
      ],
    );
  }
}