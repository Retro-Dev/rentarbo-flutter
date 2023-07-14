import 'package:flutter/cupertino.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';



class APage extends StatefulWidget {
  static const String route = "Chat";

  const APage({Key? key}) : super(key: key);

  @override
  State<APage> createState() => APageState();
}

class APageState extends State<APage> with Observer {

  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }


  @override
  update(Observable observable, String? notifyName, Map? map) {

    setState((){});
    // TODO: implement update
    // throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
