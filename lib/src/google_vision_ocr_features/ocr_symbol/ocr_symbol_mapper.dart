import '../../mappers/mapper.dart';
import '../ocr_bounding_box/ocr_bounding_box.dart';
import 'ocr_symbol.dart';

class OcrSymbolMapper implements Mapper<Map<String, dynamic>, OcrSymbol> {
  const OcrSymbolMapper({required this.boundingBoxMapper});

  final Mapper<Map<String, dynamic>, OcrBoundingBox> boundingBoxMapper;

  @override
  OcrSymbol map(Map<String, dynamic> dataModel) {
    return OcrSymbol(
      boundingBox: boundingBoxMapper.map(dataModel['boundingBox'] as Map<String, dynamic>),
      character: dataModel['text'] as String,
      confidence: dataModel['confidence'] as double,
    );
  }
}
