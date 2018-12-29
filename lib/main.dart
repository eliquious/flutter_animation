import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation/reveal_painter.dart';

void main() {
//  timeDilation = 2.0;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
      ),
      home: MyHomePage(title: 'Flutter Animation Demo', callback: execute),
    );
  }

  Future execute() {
    return new Future.delayed(Duration(seconds: 2));
  }
}

typedef Future ExecutorFunction();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.callback}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final ExecutorFunction callback;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AnimationState { still, animating, completed }

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin<MyHomePage> {
  AnimationState state = AnimationState.still;
  int _counter = 0;
//  double _fraction = 0.0;
//  double _opacity = 1.0;
  AnimationController buttonController;
  Animation<double> fractionAnimation;
  Animation<double> opacityAnimation;
  Animation<Offset> offsetAnimation;
  GlobalKey buttonKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    buttonController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    buttonController.addListener(() {
      setState(() {});
    });

    fractionAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.667,
        curve: Curves.easeIn,
      ),
    ));

    opacityAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.250,
        curve: Curves.easeIn,
      ),
    ));

    offsetAnimation = Tween<Offset>(
      begin: new Offset(0.0, 0.0),
      end: new Offset(1.0, 0.0),
    ).animate(new CurvedAnimation(
        parent: buttonController,
        curve: new Interval(
          0.25,
          0.999,
          curve: Curves.ease,
        )));
  }

  initializeAlignmentAnimation(Size screenSize) {
//    print("SCREENSIZE: $screenSize");

    final RenderBox renderBox = buttonKey.currentContext.findRenderObject();
    final size = renderBox.size;
//    print("SIZE: $size");

    final position = renderBox.localToGlobal(Offset.zero);
//    print("POSITION: $position");

    offsetAnimation = Tween<Offset>(
      begin: new Offset(position.dx - screenSize.width / 2 + size.width / 2,
          position.dy - size.height - 56.0),
      end: new Offset(0.0,
          screenSize.height / 2 - 20.0 - size.height - screenSize.height / 6),
    ).animate(new CurvedAnimation(
        parent: buttonController,
        curve: new Interval(
          0.1,
          0.750,
          curve: Curves.easeOut,
        )));
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

  void _done() async {
    setState(() {
      state = AnimationState.completed;
    });
    new Future.delayed(Duration(milliseconds: 750), () {
      _reset();
    });
  }

  void _reset() {
    setState(() {
      state = AnimationState.still;
      buttonController.reset();
    });
  }

  Future<Null> _playAnimation(Size screenSize) async {
    try {
      setState(() {
        state = AnimationState.animating;
      });
      initializeAlignmentAnimation(screenSize);
      await buttonController.forward();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
//    print("Fraction: " + fractionAnimation.value.toString());
//    print("Opacity: " + opacityAnimation.value.toString());
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
//        scrollDirection: Axis.vertical,
          child: Stack(
//          fit: StackFit.expand,
              children: <Widget>[
            Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('You have pushed the button this many times:'),
                    Padding(padding: EdgeInsets.only(top: 16.0)),
                    Text('$_counter', style: themeData.textTheme.display1),
                    Container(
                        padding: EdgeInsets.only(top: 250.0, right: 75.0),
                        child: CustomPaint(
                            child: Container(
                                child: Opacity(
                                    opacity: opacityAnimation.value,
                                    child: RaisedButton(
                                      key: buttonKey,
                                      onPressed: () {
                                        _playAnimation(
                                            MediaQuery.of(context).size);
                                        widget.callback().then((_) {
                                          _done();
                                        });
                                      },
                                      child: Text("Click Here"),
                                      color: themeData.accentColor,
                                      textColor: Colors.white,
                                    ))),
                            painter: RevealPainter(
                                fraction: fractionAnimation.value,
                                fillColor: Colors.white,
                                screenSize: MediaQuery.of(context).size))),
                  ]),
            ),
            ProgressIndicator(
                opacity: opacityAnimation.value,
                offset: offsetAnimation.value,
                state: state,
                description: (state == AnimationState.animating)
                    ? "Calculating..."
                    : ""),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  final double opacity;
  final Offset offset;
  final AnimationState state;
  final String description;

  ProgressIndicator({this.opacity, this.offset, this.state, this.description});

  @override
  Widget build(BuildContext context) {
    Widget child;
    Widget icon;
    if (state == AnimationState.animating) {
      icon = new CircularProgressIndicator(
          value: null,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor));
    } else {
      icon = new Icon(Icons.check,
          color: Theme.of(context).accentColor, size: 40.0);
    }

    if (state == AnimationState.still) {
      child = Container();
    } else {
      child = Column(children: <Widget>[
        icon,
        SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(description, textAlign: TextAlign.center))),
      ]);
    }

    return Container(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: offset,
        child: Opacity(opacity: 1.0 - opacity, child: Container(child: child)),
      ),
    );
  }
}
