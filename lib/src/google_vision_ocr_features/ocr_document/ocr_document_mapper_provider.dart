import '../../../ocr_parser.dart';
import '../language_confidence/language_confidence_mapper.dart';
import '../ocr_block/ocr_block_mapper.dart';
import '../ocr_bounding_box/ocr_bounding_box_mapper.dart';
import '../ocr_page/ocr_page_mapper.dart';
import '../ocr_paragraph/ocr_paragraph_mapper.dart';
import '../ocr_symbol/ocr_symbol_mapper.dart';
import '../ocr_word/ocr_word_mapper.dart';
import 'ocr_document.dart';

Mapper<List<Map<String, dynamic>>, OcrDocument> provideDocumentMapper(() dataModel) {
  final boundingBoxMapper = OcrBoundingBoxMapper(verticesMapper: ListMapper(VertexMapper()));
  return ListMapper(
    OcrPageMapper(
      blocksMapper: ListMapper(
        OcrBlockMapper(
          paragraphMapper: ListMapper(
            OcrParagraphMapper(
              wordsMapper: ListMapper(
                OcrWordMapper(
                  symbolsMapper: ListMapper(OcrSymbolMapper(boundingBoxMapper: boundingBoxMapper)),
                  boundingBoxMapper: boundingBoxMapper,
                ),
              ),
              boundingBoxMapper: boundingBoxMapper,
            ),
          ),
          boundingBoxMapper: boundingBoxMapper,
        ),
      ),
      languageConfidenceMapper: ListMapper(LanguageConfidenceMapper()),
    ),
  );
}
