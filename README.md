# brother_label_printer

Brother label printing plugin by Bridges
Only work for Brother label printer model QL_820NWM and label DK-11202 (62mm*100mm)

## Installation
1. Add to pubspec.yaml
```yaml
brother_label_printer:
  git:
    url: https://github.com/bridges2021/brother_label_printer.git
    ref: main
```
2. Copy /android/libs/BrotherPrintLibrary.aar to yourApp/android/libs
3. Add use premission to yourApp/android/app/src/main/AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET" />
```
4. Finish
## How to use
```dart
BrotherLabelPrinter.printFromPath('printer ip address', 'file path')
```
