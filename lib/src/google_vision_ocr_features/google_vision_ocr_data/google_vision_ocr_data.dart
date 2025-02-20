
import '../ocr_document/ocr_document.dart';

class GoogleVisionOcrData {
  const GoogleVisionOcrData({required this.text, required this.ocrDocument});

  final String text;
  final OcrDocument ocrDocument;
}
