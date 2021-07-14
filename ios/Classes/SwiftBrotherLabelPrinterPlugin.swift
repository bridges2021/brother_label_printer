import Flutter
import UIKit
import BRLMPrinterKit

public class SwiftBrotherLabelPrinterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.bridges/brother_label_printer", binaryMessenger: registrar.messenger())
    let instance = SwiftBrotherLabelPrinterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "printLabel") {
        printLabel(args: call.arguments)
    } else if (call.method == "fileExist") {
        fileExist(args: call.arguments)
    }
  }
    
    public func fileExist(args: Any?) {
        let pickedFileUrl = args as? String ?? ""
        print("picked file exist? \(FileManager.default.fileExists(atPath: pickedFileUrl))")
        let url = URL.init(fileURLWithPath: pickedFileUrl)
        print("URL: \(String(describing: url))")
        do {
            try url.checkResourceIsReachable()
            print("URL reachable")
        } catch {
            print("URL not reachable")
        }
    }

  public func printLabel(args: Any?) {
    guard let argsMap = args as? Dictionary<String, AnyObject>,
          let path = argsMap["path"] as? String,
          let ip = argsMap["ip"] as? String
    else {
        print("Missing or invalid arguments")
        return
    }
    
    let url = URL.init(fileURLWithPath: path)
    
    let channel = BRLMChannel(wifiIPAddress: ip)

    let generateResult = BRLMPrinterDriverGenerator.open(channel)
    guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
        let printerDriver = generateResult.driver else {
            print("Error - Open Channel: \(generateResult.error.code)")
            return
    }
    defer {
        printerDriver.closeChannel()
    }
    
    guard
        let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
        else {
            print("Error - PDF file is not found.")
            return
    }

    printSettings.labelSize = .dieCutW62H100
    printSettings.autoCut = true

    let printError = printerDriver.printPDF(with: url, settings: printSettings)

    if printError.code != .noError {
        print("Error - Print PDF: \(printError)")
    }
    else {
        print("Success - Print Image")
    }
  }
}
