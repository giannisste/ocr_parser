import '../../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import '../../core/mappers/mapper.dart';
import 'bounding_box_map.dart';

class BoundingBoxToWordMapper implements Mapper<BoundingBoxMap, Map<String, OcrParagraph?>> {
  const BoundingBoxToWordMapper({required this.boundingBoxMapper});

  final Mapper<TargetWord, OcrParagraph?> boundingBoxMapper;

  @override
  Map<String, OcrParagraph?> map(BoundingBoxMap dataModel) =>
      dataModel.map((key, value) => MapEntry(key, boundingBoxMapper.map(value)));
}
