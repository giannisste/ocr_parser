import '../../core/mappers/mapper.dart';
import '../language_confidence/language_confidence.dart';
import '../ocr_block/ocr_block.dart';
import 'ocr_page.dart';

class OcrPageMapper implements Mapper<Map<String, dynamic>, OcrPage> {
  OcrPageMapper({required this.blocksMapper, required this.languageConfidenceMapper});

  final Mapper<List<Map<String, dynamic>>, List<OcrBlock>> blocksMapper;
  final Mapper<List<Map<String, dynamic>>, List<LanguageConfidence>> languageConfidenceMapper;

  @override
  OcrPage map(Map<String, dynamic> dataModel) {
    return OcrPage(
      size: ((dataModel['width'] as int).toDouble(), (dataModel['height'] as int).toDouble()),
      confidence: dataModel['confidence'] as double,
      languageConfidences: languageConfidenceMapper.map(
        ((dataModel['property'] as Map<String, dynamic>)['detectedLanguages'] as List)
            .cast<Map<String, dynamic>>(),
      ),
      blocks: blocksMapper.map((dataModel['blocks'] as List).cast<Map<String, dynamic>>()),
    );
  }
}
