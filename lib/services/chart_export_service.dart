import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChartExportService {
  Future<String> saveChartImage(Uint8List bytes, String fileName) async {
    try {
      if (kIsWeb) {
        final blob = html.Blob([bytes], 'image/png');
        final url = html.Url.createObjectUrl(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
        return 'Download Succes (Web)';
      } else if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }

        await ImageGallerySaver.saveImage(
          bytes,
          name: fileName.replaceAll(RegExp(r'[^\w\s\-.]'), ''),
          quality: 100,
        );

        final directory = await getApplicationDocumentsDirectory();
        String path = '${directory.path}/$fileName.png';
        File file = File(path);
        await file.writeAsBytes(bytes);
        return path;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final downloadsDirectory = await getDownloadsDirectory();
        if (downloadsDirectory == null) {
          throw Exception('Could not find the downloads directory.');
        }

        final filePath = '${downloadsDirectory.path}/$fileName.png';
        final file = File(filePath);

        await file.writeAsBytes(bytes);
        return filePath;
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } catch (e) {
      throw Exception('Failed to save chart ${e.toString()}');
    }
  }
}
