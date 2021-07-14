import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:brother_label_printer/brother_label_printer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Brother Label Printer example'),
        ),
        body: ListView(
          children: [
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
                onPressed: () async {
                  final _pdf = pw.Document();
                  _pdf.addPage(pw.Page(
                      pageFormat: PdfPageFormat(100, 62),
                      build: (pw.Context context) {
                        return pw.Center(
                            child: pw.BarcodeWidget(
                                data: 'Testing 123 !@#',
                                barcode: pw.Barcode.qrCode()));
                      }));
                  final tempDir = await getTemporaryDirectory();
                  final file = File('${tempDir.path}/example.pdf');
                  await file.writeAsBytes(await _pdf.save());
                  await BrotherLabelPrinter.printFromPath(
                      _controller.text, file.path);
                },
                child: Text('Print sample')),
            ElevatedButton(
                onPressed: () async {
                  print('creating pdf');
                  final _pdf = pw.Document();
                  print('adding pdf page');
                  _pdf.addPage(pw.Page(
                      pageFormat: PdfPageFormat(100, 62),
                      build: (pw.Context context) {
                        return pw.Center(
                            child: pw.BarcodeWidget(
                                data: 'Testing 123 !@#',
                                barcode: pw.Barcode.qrCode()));
                      }));
                  print('getting temporary directory');
                  final tempDir = await getTemporaryDirectory();
                  final file = File('${tempDir.path}/example.pdf');
                  print('pdf saving to ${file.path}');
                  await file.writeAsBytes(await _pdf.save());
                  print('calling file exist method');
                  await BrotherLabelPrinter.fileExist(file.path);
                },
                child: Text('File exist'))

          ],
        ),
      ),
    );
  }
}
