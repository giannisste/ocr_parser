import '../../mappers/mapper.dart';
import '../ocr_document/ocr_document.dart';
import 'google_vision_ocr_data.dart';

class GoogleVisionOcrDataMapper implements Mapper<Map<String, dynamic>, GoogleVisionOcrData> {
  const GoogleVisionOcrDataMapper({required this.ocrDocumentMapper});

  final Mapper<List<Map<String, dynamic>>, OcrDocument> ocrDocumentMapper;
  @override
  GoogleVisionOcrData map(Map<String, dynamic> dataModel) {
    final responses = (dataModel['responses'] as List<dynamic>).cast<Map<String, dynamic>>();
    final fullTextAnnotations = responses.first['fullTextAnnotation'] as Map<String, dynamic>;
    final text = fullTextAnnotations['text'] as String;
    final pages = (fullTextAnnotations['pages'] as List).cast<Map<String, dynamic>>();
    final ocrDocument = ocrDocumentMapper.map(pages);
    return GoogleVisionOcrData(text: text, ocrDocument: ocrDocument);
  }
}
