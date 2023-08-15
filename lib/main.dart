import 'package:flutter/material.dart';
import 'package:os_mobile_scanner/screens/barcode_scanner.screen.dart';
import 'package:os_mobile_scanner/screens/qr_scanner.screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;

  final Uri _sourceCodeUrl =
      Uri.parse('https://github.com/OpenGoose/mobile-scanner');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await launchUrl(_sourceCodeUrl);
              },
              icon: const Icon(Icons.code))
        ],
      ),
      body: Center(
        child: [
          const QrScannerScreen(),
          const BarcodeScannerScreen()
        ][_currentPage],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        selectedIndex: _currentPage,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.qr_code), label: 'QR'),
          NavigationDestination(
              icon: Icon(Icons.barcode_reader), label: 'Barcode')
        ],
      ),
    );
  }
}
