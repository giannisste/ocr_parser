import 'dart:convert';
import 'dart:io' show File;

import '../../core_types/usecases/usecase.dart';
import '../../mappers/mapper.dart';
import '../google_vision_ocr_data/google_vision_ocr_data.dart';
import '../google_vision_ocr_response/google_vision_ocr_response.dart';

class FileGoogleVisionOcrUsecase implements Usecase<GoogleVisionOcrResponse, String> {
  const FileGoogleVisionOcrUsecase({required this.googleOcrDataMapper});

  final Mapper<Map<String, dynamic>, GoogleVisionOcrData> googleOcrDataMapper;

  @override
  Future<GoogleVisionOcrResponse> execute(String event) async {
    try {
      final file = File('./example/dei_response.json');
      final content = await file.readAsString();
      final jsonContent = jsonDecode(content) as Map<String, dynamic>;
      final responsesContent = (jsonContent['responses'] as List).cast<Map<String, dynamic>>()[0];
      final fullTextAnnotation = responsesContent['fullTextAnnotation'] as Map<String, dynamic>;
      final googleOcrData = googleOcrDataMapper.map(fullTextAnnotation);
      return GoogleVisionOcrResponse.left(googleOcrData);
    } catch (e) {
      return GoogleVisionOcrResponse.right(e.toString());
    }
  }
}
