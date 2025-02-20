import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_paragraph/ocr_paragraph.dart';

class OcrBlock {
  const OcrBlock({
    required this.boundingBox,
    required this.paragraphs,
    required this.blockType,
    required this.confidence,
  });

  final OcrBoundingBox boundingBox;
  final List<OcrParagraph> paragraphs;
  final OcrBlockType blockType;
  final double confidence;
}

enum OcrBlockType { text, image }
