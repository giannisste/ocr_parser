import '../../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import '../document_format/document_format.dart';

class OcrParsedDocument {
  const OcrParsedDocument({required this.documentFormat, required this.paragraphMap});

  final DocumentFormat documentFormat;
  final Map<String, OcrParagraph?> paragraphMap;
}
