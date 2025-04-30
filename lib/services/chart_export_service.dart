import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChartExportService {
  Future<String> saveChartImage(Uint8List bytes, String fileName) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
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
    } catch (e) {
      throw Exception('Failed to save chart ${e.toString()}');
    }
  }
}
