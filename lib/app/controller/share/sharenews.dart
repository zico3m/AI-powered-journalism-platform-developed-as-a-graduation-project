import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
class NewsController extends GetxController {

  void shareNews({
    required String title,
    required String description,
    String? url,
  }) {
    final text = '''
$title

$description
${url ?? ''}
''';

    Share.share(text);
  }
}
