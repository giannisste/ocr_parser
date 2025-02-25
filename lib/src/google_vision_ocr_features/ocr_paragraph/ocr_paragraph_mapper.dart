import '../../core/mappers/mapper.dart';
import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_word/ocr_word.dart';
import 'ocr_paragraph.dart';

class OcrParagraphMapper implements Mapper<Map<String, dynamic>, OcrParagraph> {
  const OcrParagraphMapper({required this.wordsMapper, required this.boundingBoxMapper});

  final Mapper<List<Map<String, dynamic>>, List<OcrWord>> wordsMapper;
  final Mapper<Map<String, dynamic>, OcrBoundingBox> boundingBoxMapper;

  @override
  OcrParagraph map(Map<String, dynamic> dataModel) {
    return OcrParagraph(
      boundingBox: boundingBoxMapper.map(dataModel['boundingBox'] as Map<String, dynamic>),
      words: wordsMapper.map((dataModel['words'] as List).cast<Map<String, dynamic>>()),
      confidence: dataModel['confidence'] as double,
    );
  }
}
