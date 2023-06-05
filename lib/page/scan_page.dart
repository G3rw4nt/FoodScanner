import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? scanResult;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Make a scan')),
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Center(
            child: Column(
          children: [
            Text(
              scanResult == null || scanResult == '-1' 
              ? 'Scan a code!' 
              : 'Scan result: $scanResult', style:const TextStyle(fontSize: 18)),
            ElevatedButton(
                onPressed: ScanBarcode, child: const Text(' Start Scan'))
          ],
        )),
      ));

  Future ScanBarcode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#00FF00", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Failed to get scan';
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);
  }
}
