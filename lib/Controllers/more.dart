import 'package:flutter/material.dart';
import '../Extensions/style.dart';
import 'MoreModel.dart';
import 'Settings/Contacts.dart';
import 'about.dart';

class MoreTab extends StatefulWidget {
  static const String route = "MoreTab";

  const MoreTab({Key? key}) : super(key: key);

  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {

  final List<MoreModel> _moreModels = [
    MoreModel(
        title: "Terms and Conditions",
        iconName: "chevron-icon.png",
        type: MoreType.tnc),
    MoreModel(
        title: "Privacy Policy",
        iconName: "chevron-icon.png",
        type: MoreType.privacy),
    MoreModel(title: "FAQs", iconName: "chevron-icon.png", type: MoreType.faqs),
    MoreModel(
        title: "Contact Us",
        iconName: "chevron-icon.png",
        type: MoreType.contact)
  ];

  int getMoreItemsCount() {
    return _moreModels.length;
  }

  String getTitleFor(int index) {
    return _moreModels[index].title;
  }

  MoreType getTypeFor(int index) {
    return _moreModels[index].type;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
          "More",
          textAlign: TextAlign.start,
          style: Style.getBoldFont(18, color: Style.textBlackColor),
        ),
      ),
      body:  MoreViewBody(),
    );
  }

  Widget MoreViewBody()
  {
   return ListView.separated(
        itemBuilder: (context, index) {
          if (index == getMoreItemsCount()) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                switch (getTypeFor(index)) {
                  case MoreType.tnc:
                    Navigator.of(context, rootNavigator: true).pushNamed(About.route,arguments: {
                      "title":"Terms & Conditions",
                      "content":"https://rentarbo.qa.retrocubedev.com/content/terms-condition",
                    });
                    break;
                  case MoreType.privacy:
                    Navigator.of(context, rootNavigator: true).pushNamed(About.route,arguments: {
                      "title":"Privacy Policy",
                      "content":"https://rentarbo.qa.retrocubedev.com/content/privacy-policy",
                    });
                    break;
                  case MoreType.faqs:
                    Navigator.of(context, rootNavigator: true).pushNamed(About.route,arguments: {
                      "title":"FAQ'S",
                      "content":"https://rentarbo.qa.retrocubedev.com/faqs",
                    });
                    break;
                  case MoreType.contact:
                    Navigator.of(context).pushNamed(ContactUs.route);
                    break;
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTitleFor(index),
                      style: Style.getSemiBoldFont(14,
                          color: Style.textBlackColorOpacity80),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      Image.asset(Style.getIconImage("chevron-icon@2x.png")),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container();
        },
        itemCount: getMoreItemsCount() );
  }
}
