import 'package:ocr_parser/ocr_parser.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_page/ocr_page.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';

import '../../core_types/usecases/usecase.dart';
import '../../documents_features/document_data/document_data.dart';
import '../../documents_features/document_response/document_response.dart';
import '../../google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';
import '../bounding_box_map/bounding_box_map.dart';
import '../bounding_box_map/bounding_box_to_word_mapper.dart';

class FindBoundingBoxesUsecase implements Usecase<DocumentResponse, GoogleVisionOcrData> {
  FindBoundingBoxesUsecase({
    required this.getBoundingBoxMapsUsecase,
    required this.documentDataMapper,
  });

  final Usecase<BoundingBoxMap, String> getBoundingBoxMapsUsecase;
  final Mapper<Map<String, OcrParagraph?>, DocumentData> documentDataMapper;

  @override
  Future<DocumentResponse> execute(GoogleVisionOcrData event) async {
    try {
      final result = await getBoundingBoxMapsUsecase.execute('DEI');
      final boundingBoxToWordMapper = BoundingBoxToWordMapper(
        boundingBoxMapper: LambdaMapper(event.ocrDocument.first.findClosestParagraph),
      );
      final foundWordsDictionary = boundingBoxToWordMapper.map(result);
      final documentData = documentDataMapper.map(foundWordsDictionary);
      return Either.left(documentData);
    } catch (e) {
      return Either.right(e.toString());
    }
  }
}
