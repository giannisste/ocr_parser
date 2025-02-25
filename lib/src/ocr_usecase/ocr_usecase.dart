import 'package:ocr_parser/src/google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';

import '../core/core_types/usecases/usecase.dart';
import '../documents_features/document_response/document_response.dart';

typedef OcrUsecase = Usecase<DocumentResponse, GoogleVisionOcrData>;
