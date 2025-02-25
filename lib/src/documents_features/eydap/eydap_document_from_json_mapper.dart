
import '../../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import '../../core/mappers/mapper.dart';
import 'eydap_document.dart';

class EydapDocumentFromJsonMapper implements Mapper<Map<String, OcrParagraph?>, EydapDocument2025> {
  const EydapDocumentFromJsonMapper(this.amountMapper);

  final Mapper<String, double?> amountMapper;

  @override
  EydapDocument2025 map(Map<String, OcrParagraph?> dataModel) => EydapDocument2025();
}

