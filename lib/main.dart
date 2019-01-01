import 'package:flutter/material.dart';
import 'package:flutter_animation/async_transition_builder.dart';
import 'package:flutter_animation/async_transition_button.dart';
import 'package:flutter_animation/reveal_painter.dart';
import 'package:flutter_animation/async_transition_animations.dart';

void main() {
//  timeDilation = 2.0;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
//          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
        ),
        home: MyHomePage(title: 'Flutter Animation Demo', callback: execute));
  }

  Future execute() {
    return new Future.delayed(Duration(seconds: 2));
  }
}

typedef Future ExecutorFunction();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.callback}) : super(key: key);

  final String title;
  final ExecutorFunction callback;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin<MyHomePage> {
  int _counter = 0;
  AnimationController buttonController;
  GlobalKey buttonKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    buttonController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    buttonController.addListener(() {
      setState(() {});
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  onComplete(String event) {
    Navigator.of(context)
        .push(new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return Scaffold(
        appBar: AppBar(title: Text("Blam! new screen")),
        body: Container(),
      );
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return new FadeTransition(opacity: animation, child: child);
    }))
          ..then((_) {
            buttonController.reset();
          });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: AsyncTransitionBuilder(
        controller: buttonController,
        onComplete: onComplete,
        inProgressText: "Calculating...",
        iconColor: themeData.textTheme.body1.color,
        textColor: themeData.textTheme.body1.color,
        builder: (BuildContext context, AsyncTransitionAnimation anim) {
          return Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('You have pushed the button this many times:'),
                  Padding(padding: EdgeInsets.only(top: 16.0)),
                  Text('$_counter', style: themeData.textTheme.display1),
                  Padding(
                    padding: const EdgeInsets.only(top: 250.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AsyncTransitionButton(
                            animation: anim,
                            fillColor: themeData.accentColor,
                            child: RaisedButton(
                              key: buttonKey,
                              onPressed: () {
                                anim.playAnimation(
                                    context, buttonKey, "button1");
                                widget.callback().then((_) {
                                  anim.done();
                                });
                              },
                              child: Text("Click Here"),
                              color: themeData.accentColor,
                              textColor: Colors.black,
                            )),
                        Opacity(
                          opacity: anim.opacity,
                          child: RaisedButton(
                            textColor: Colors.black,
                            color: themeData.accentColor,
                            onPressed: _incrementCounter,
                            child: Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                  ),
//                  Container(
//                      padding: EdgeInsets.only(top: 250.0, right: 75.0),
//                      child: ),
                ]),
          );
        },
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
