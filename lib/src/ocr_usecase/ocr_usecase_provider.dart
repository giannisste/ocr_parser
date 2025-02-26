import 'package:ocr_parser/src/google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';

import '../bounding_box_method_features/find_bounding_boxes_usecase.dart';
import '../documents_features/cosmote/cosmote_document_from_json_mapper.dart';
import '../documents_features/cosmote/get_cosmote_bounding_box_map_usecase.dart';
import '../documents_features/dei/dei_document_from_json_mapper.dart';
import '../documents_features/dei/get_dei_bounding_box_map_usecase.dart';
import '../documents_features/document_data/document_data_from_json_mapper.dart';
import '../documents_features/document_data/get_document_bounding_box_map_usecase.dart';
import '../documents_features/document_format/find_document_format_usecase.dart';
import '../documents_features/eydap/eydap_document_from_json_mapper.dart';
import '../documents_features/eydap/get_eydap_bounding_box_map_usecase.dart';
import '../documents_features/nova/get_nova_bounding_box_map_usecase.dart';
import '../documents_features/nova/nova_document_from_json_mapper.dart';
import 'ocr_usecase.dart';

OcrUsecase provideOcrUsecase(GoogleVisionOcrData ocrData) {
  return FindBoundingBoxesUsecase(
    findDocumentFormatUsecase: const FindDocumentFormatUsecase(),
    preprocessDocumentUsecase: PreprocessOcrUsecase(
      getTargetBoxesUsecase: GetTargetBoxesUsecase(ocrData),
    ),
    getBoundingBoxMapsUsecase: GetDocumentBoundingBoxMapUsecase(
      getDeiBoundingBoxMapUsecase: GetDeiBoundingBoxMapUsecase(),
      getEydapBoundingBoxMapUsecase: GetEydapBoundingBoxMapUsecase(),
      getCosmoteBoundingBoxMapUsecase: GetCosmoteBoundingBoxMapUsecase(),
      getNovaBoundingBoxMapUsecase: GetNovaBoundingBoxMapUsecase(),
    ),
    documentDataMapper: DocumentDataFromJsonMapper(
      deiMapper: DeiDocumentFromJsonMapper(AmountMapper()),
      eydapMapper: EydapDocumentFromJsonMapper(AmountMapper()),
      cosmoteMapper: CosmoteDocumentFromJsonMapper(AmountMapper()),
      novaMapper: NovaDocumentFromJsonMapper(AmountMapper()),
    ),
  );
}
