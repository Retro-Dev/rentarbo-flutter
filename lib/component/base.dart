import 'package:flutter/material.dart';
import '../component/custom_appbar.dart';

import '../Extensions/style.dart';

class BaseView extends StatelessWidget {
  final Widget body;
  final String title;
  const BaseView({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.textWhiteColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomAppBar(appBarTitle: title),
            )),
        body: SafeArea(child: body));
  }
}
