import 'package:ocr_parser/src/core/core_types/predicates/and_predicate.dart';
import 'package:ocr_parser/src/core/core_types/predicates/substring_predicate.dart';

import '../../core/core_types/usecases/usecase.dart';
import '../../google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';
import 'document_format.dart';

class FindDocumentFormatUsecase
    implements Usecase<DocumentFormatResponse, GoogleVisionOcrData> {
  const FindDocumentFormatUsecase();

  @override
  Future<DocumentFormatResponse> execute(GoogleVisionOcrData event) {
    var documentFormatResponse = DocumentFormatResponse.right(
      const UnknownDocumentFormat(),
    );
    for (final page in event.ocrDocument) {
      for (final block in page.blocks) {
        for (final paragraph in block.paragraphs) {
          final paragraphText = paragraph.toParagraph().trim().toUpperCase();
          documentFormatResponse = paragraphText.foldDocumentFormat(
            const OrPredicate(
              firstPredicate: SubstringPredicate(substring: 'DEI'),
              secondPredicate: SubstringPredicate(substring: 'ΔΕΗ'),
            ),
            const SubstringPredicate(substring: 'EYDAP'),
            const SubstringPredicate(substring: 'COSMOTE'),
            const SubstringPredicate(substring: 'NOVA'),
          );
          if (documentFormatResponse.isLeft) {
            return Future.value(documentFormatResponse);
          }
        }
      }
    }
    return Future.value(documentFormatResponse);
  }
}
