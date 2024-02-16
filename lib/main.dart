import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> dispositivos = [];

  @override
  void initState() {
    super.initState();
    pascanear();
  }

  Future<void> pascanear() async {
    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      setState(() {
        dispositivos = results;
      });
    });
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 3), androidUsesFineLocation: true);
  }

  Future<void> paconectar(BluetoothDevice device) async {
    await device.connect();
  }

  Future<void> padisconectar(BluetoothDevice device) async {
    await device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        backgroundColor: Color.fromARGB(255, 218, 6, 6),
      ),
      body: ListView.builder(
        itemCount: dispositivos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dispositivos[index].device.name ?? 'Nada'),
            subtitle: Text(dispositivos[index].device.id.toString()),
            trailing: dispositivos[index].device.isConnected
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      padisconectar(dispositivos[index].device);
                    },
                    child: const Text('Desconectar'),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      paconectar(dispositivos[index].device);
                    },
                    child: const Text('Conectar'),
                  ),
          );
        },
      ),
    );
  }
}