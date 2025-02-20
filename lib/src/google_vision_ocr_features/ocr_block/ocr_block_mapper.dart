import '../../mappers/mapper.dart';
import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_paragraph/ocr_paragraph.dart';
import 'ocr_block.dart';

class OcrBlockMapper implements Mapper<Map<String, dynamic>, OcrBlock> {
  const OcrBlockMapper({required this.paragraphMapper, required this.boundingBoxMapper});

  final Mapper<List<Map<String, dynamic>>, List<OcrParagraph>> paragraphMapper;
  final Mapper<Map<String, dynamic>, OcrBoundingBox> boundingBoxMapper;

  @override
  OcrBlock map(Map<String, dynamic> dataModel) {
    return OcrBlock(
      boundingBox: boundingBoxMapper.map(dataModel['boundingBox'] as Map<String, dynamic>),
      paragraphs:
          paragraphMapper.map((dataModel['paragraphs'] as List).cast<Map<String, dynamic>>()),
      blockType: dataModel['blockType'] == 'TEXT' ? OcrBlockType.text : OcrBlockType.image,
      confidence: dataModel['confidence'] as double,
    );
  }
}
