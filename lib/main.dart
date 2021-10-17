import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final port = 1883;
  final subnet = "192.168.0";
  final timeout = Duration(seconds: 5);

  String lastFound = "";

  TextEditingController subNetMask = new TextEditingController(text: "192.168.0");
  TextEditingController portScan = new TextEditingController(text: "1883");

  final scanner = LanScanner();

  void _incrementCounter() {
    setState(() {
      _counter++;
      BigInt bi = BigInt.parse("9765857685645634745683213783469802697862459786234978569765857685645634745683213783469802697862459786234978569137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697657856");
      BigInt e = BigInt.parse("97658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347456832137834698026978624597862349785697658576856456347476585768564563474568321378346980269786245978623497856");
      BigInt m = BigInt.parse("976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856976585768564563474568321378346980269786245978623497856");
      print(bi.modPow(e, m));
    });
  }

  void scanNetwork(String subnet, int port) {
    setState(() {
      _counter++;
      final stream = scanner.quickScan(
        subnet: subnet,
        timeout: Duration(seconds: 1),
        port: port,
        verbose: false,
      );

      // final stream = scanner.preciseScan(
      //   subnet,
      //   progressCallback: (ProgressModel progress) {
      //     print('${progress.percent * 100}% 192.168.0.${progress.currIP}');
      //   },
      // );

      stream.listen((DeviceModel device) {
        if (device.exists) {
          print("Found device on ${device.ip}:${device.port}");
          onFound("Found device on ${device.ip}:${device.port}");
        }
      });
    });
  }

  void onFound(String foundIp) {
    setState(() {
      DateTime now = DateTime.now();
      String convertedDateTime = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}";
      lastFound = "\n\n>>"+convertedDateTime+": "+ foundIp +"\n"+
          lastFound;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              Text("SubNetMask:  "),
              new Expanded(child: TextField(controller: subNetMask,
                  keyboardType: TextInputType.numberWithOptions(decimal: true))),
              new IconButton(
                icon: new Icon(Icons.cast_connected, color: Colors.green),
                iconSize: 40.0,
                onPressed: () {
                  scanNetwork(subNetMask.text, int. parse(portScan.text));
                },
              ),
            ]),
            new Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              Text("Port to scan:  "),
              new Expanded(child: TextField(controller: portScan,
                  keyboardType: TextInputType.numberWithOptions(decimal: true))),
            ]),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: Text(
                  '$lastFound',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
