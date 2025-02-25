import 'package:ocr_parser/src/core/core_types/either/either.dart';
import 'package:ocr_parser/src/core/core_types/usecases/usecase.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_page/ocr_page.dart';

import '../core/mappers/lambda_mapper.dart';
import '../core/mappers/mapper.dart';
import '../documents_features/document_data/document_data.dart';
import '../documents_features/document_format/document_format.dart';
import '../documents_features/document_response/document_response.dart';
import '../documents_features/ocr_parsed_document/ocr_parsed_document.dart';
import '../google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';
import 'bounding_box_map/bounding_box_map.dart';
import 'bounding_box_map/bounding_box_to_word_mapper.dart';

class FindBoundingBoxesUsecase
    implements Usecase<DocumentResponse, GoogleVisionOcrData> {
  FindBoundingBoxesUsecase({
    required this.getBoundingBoxMapsUsecase,
    required this.documentDataMapper,
    required this.findDocumentFormatUsecase,
  });

  final Usecase<BoundingBoxMap, DocumentFormat> getBoundingBoxMapsUsecase;
  final Mapper<OcrParsedDocument, DocumentData> documentDataMapper;
  final Usecase<DocumentFormatResponse, GoogleVisionOcrData>
  findDocumentFormatUsecase;

  @override
  Future<DocumentResponse> execute(GoogleVisionOcrData event) async {
    try {
      final boundingBoxToWordMapper = BoundingBoxToWordMapper(
        boundingBoxMapper: LambdaMapper(
          event.ocrDocument.first.findClosestParagraph,
        ),
      );
      final documentFormatResponse = await findDocumentFormatUsecase.execute(
        event,
      );
      return await documentFormatResponse.fold(
        (documentFormat) async {
          final result = await getBoundingBoxMapsUsecase.execute(
            documentFormat,
          );
          final foundWordsDictionary = boundingBoxToWordMapper.map(result);
          final ocrParsedDocument = OcrParsedDocument(
            documentFormat: documentFormat,
            paragraphMap: foundWordsDictionary,
          );
          final documentData = documentDataMapper.map(ocrParsedDocument);
          return DocumentResponse.left(documentData);
        },
        (unknownDocument) {
          return Future.value(DocumentResponse.right('Unknown document'));
        },
      );
    } catch (e) {
      return DocumentResponse.right(e.toString());
    }
  }
}
