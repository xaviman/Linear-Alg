import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:linearAlg/RREF.dart';
import 'package:linearAlg/GSO.dart';
import 'EVEV.dart';
import 'EQNSOL.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linear Algebra Functions',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Linear Algebra Functions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Widget menuCard(String title, String bgImage, var nav) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nav),
        )
      },
      child: Container(
        height: 60,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: new DecorationImage(
            image: new AssetImage(bgImage),
            fit: BoxFit.cover,
          ),
        ),
        // child: new BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        //   child: new Container(
        // decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),

        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <Widget>[
            menuCard("RREF", "assets/image/RREF_B.jpg", RREF()),
            menuCard("GS", "assets/image/GSO_B.jpg", GSO()),
            menuCard("Eigen Values\nEigen Vectors",
                "assets/image/EVEV.jpg", EVEV()),
            menuCard(
                "Equation\nSolver", "assets/image/EQN.jpg", EQNSOL()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
