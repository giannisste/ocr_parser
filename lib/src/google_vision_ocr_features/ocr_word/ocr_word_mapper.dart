import '../../core/mappers/mapper.dart';
import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_symbol/ocr_symbol.dart';
import 'ocr_word.dart';

class OcrWordMapper implements Mapper<Map<String, dynamic>, OcrWord> {
  const OcrWordMapper({required this.symbolsMapper, required this.boundingBoxMapper});

  final Mapper<List<Map<String, dynamic>>, List<OcrSymbol>> symbolsMapper;
  final Mapper<Map<String, dynamic>, OcrBoundingBox> boundingBoxMapper;

  @override
  OcrWord map(Map<String, dynamic> dataModel) {
    return OcrWord(
      boundingBox: boundingBoxMapper.map(dataModel['boundingBox'] as Map<String, dynamic>),
      symbols: symbolsMapper.map((dataModel['symbols'] as List).cast<Map<String, dynamic>>()),
      confidence: dataModel['confidence'] as double,
    );
  }
}
