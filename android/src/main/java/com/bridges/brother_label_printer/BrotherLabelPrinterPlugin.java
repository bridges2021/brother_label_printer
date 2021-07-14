package com.bridges.brother_label_printer;

import android.graphics.Bitmap;
import android.graphics.pdf.PdfRenderer;
import android.os.Environment;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.brother.ptouch.sdk.LabelInfo;
import com.brother.ptouch.sdk.Printer;
import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.PrinterStatus;

import java.io.File;
import java.nio.file.FileSystems;
import java.util.ArrayList;
import java.util.Map;

/** BrotherLabelPrinterPlugin */
public class BrotherLabelPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.bridges/brother_label_printer");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("printLabel")) {
      printLabel(call.arguments);
    } else if (call.method.equals("fileExist")) {
      fileExist(call.arguments);
    } else if (call.method.equals("printImage")) {
      printImage(call.<Bitmap>argument("bitmap"));
    }
  }

  private ArrayList<Bitmap> pdfToBitmap(File pdfFile) {
    ArrayList<Bitmap> bitmaps = new ArrayList<>();

    try {
      PdfRenderer renderer = new PdfRenderer(ParcelFileDescriptor.open(pdfFile, ParcelFileDescriptor.MODE_READ_ONLY));

      Bitmap bitmap;
      final int pageCount = renderer.getPageCount();
      for (int i = 0; i < pageCount; i++) {
        PdfRenderer.Page page = renderer.openPage(i);

        int width = 62;
        int height = 100;
        bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);

        page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);

        bitmaps.add(bitmap);

        // close the page
        page.close();

      }

      // close the renderer
      renderer.close();
    } catch (Exception ex) {
      ex.printStackTrace();
    }

    return bitmaps;

  }

  void printImage(final Bitmap bitmap) {
    // Specify printer
    final Printer printer = new Printer();
    PrinterInfo settings = printer.getPrinterInfo();
    settings.printerModel = PrinterInfo.Model.QL_820NWB;
    settings.port = PrinterInfo.Port.NET;
    settings.ipAddress = "your-printer-ip";
    settings.workPath = "Context.writable-dir-path";

    // Print Settings
    settings.labelNameIndex = LabelInfo.QL1100.W102H51.ordinal();
    settings.printMode = PrinterInfo.PrintMode.FIT_TO_PAGE;
    settings.isAutoCut = true;
    printer.setPrinterInfo(settings);

    // Connect, then print
    new Thread(new Runnable() {
      @Override
      public void run() {
        if (printer.startCommunication()) {
          PrinterStatus result = printer.printImage(bitmap);
          if (result.errorCode != PrinterInfo.ErrorCode.ERROR_NONE) {
            Log.d("TAG", "ERROR - " + result.errorCode);
          }
          printer.endCommunication();
        }
      }
    }).start();
  }

  void fileExist(@NonNull Object args) {
    final String path = (String) args;
    Log.d("TAG", "Path " + path);
    final File file = new File(path);
    Log.d("TAG", "File exist? " + file.exists());

    Log.d("TAG", "File path writable " + file.canWrite() + " Filepath readable " + file.canRead());

    File dir = file.getParentFile();
    Log.d("TAG", "Dir: " + dir.getAbsolutePath() + " Writable" + dir.canWrite());
  }

  void printLabel(@NonNull Object args) {
    final Map map = (Map) args;
    final String ip = (String) map.get("ip");
    final String path = (String) map.get("path");

    Log.d("TAG", "IP " + ip + "Path " + path);

    // Specify printer
    final Printer printer = new Printer();
    PrinterInfo settings = printer.getPrinterInfo();
    settings.printerModel = PrinterInfo.Model.QL_820NWB;
    settings.port = PrinterInfo.Port.NET;
    settings.ipAddress = ip;
    settings.workPath = new File(path).getParent();
    Log.d("TAG", "Work path: " + settings.workPath + " Write access: " + new File(settings.workPath).canWrite());

    // Print Settings
    settings.labelNameIndex = LabelInfo.QL1100.W62H100.ordinal();
    settings.printMode = PrinterInfo.PrintMode.FIT_TO_PAGE;
    settings.isAutoCut = true;
    printer.setPrinterInfo(settings);

    // Connect, then print
    new Thread(new Runnable() {
      @Override
      public void run() {
        if (printer.startCommunication()) {
          PrinterStatus result = printer.printPdfFile(path, 1);
          if (result.errorCode != PrinterInfo.ErrorCode.ERROR_NONE) {
            Log.d("TAG", "ERROR - " + result.errorCode);
          }
          printer.endCommunication();
        }
      }
    }).start();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
