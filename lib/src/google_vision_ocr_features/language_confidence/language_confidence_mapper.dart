import '../../mappers/mapper.dart';
import 'language_confidence.dart';

class LanguageConfidenceMapper implements Mapper<Map<String, dynamic>, LanguageConfidence> {
  @override
  LanguageConfidence map(Map<String, dynamic> dataModel) => LanguageConfidence(
    language: dataModel['languageCode'] as String,
    confidence: dataModel['confidence'] as double,
  );
}
