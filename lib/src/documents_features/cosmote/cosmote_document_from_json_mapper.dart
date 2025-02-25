
import '../../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import '../../core/mappers/mapper.dart';
import 'cosmote_document.dart';

class CosmoteDocumentFromJsonMapper implements Mapper<Map<String, OcrParagraph?>, CosmoteDocument> {
  const CosmoteDocumentFromJsonMapper(this.amountMapper);

  final Mapper<String, double?> amountMapper;

  @override
  CosmoteDocument map(Map<String, OcrParagraph?> dataModel) {
    DateTime? parsed;
    try {
      final date = dataModel['dueDate']?.toParagraph().trim() ?? '';
      final parts = date.split('/').map(int.parse).toList();
      parsed = DateTime(parts[2], parts[1], parts[0]);
    } catch (e) {
      parsed = null;
    }
    return CosmoteDocument(
      rfCode: dataModel['rfCode']?.toParagraph().trim() ?? 'Not found',
      paymentAmount: amountMapper.map(dataModel['totalAmount']?.toParagraph() ?? '-1.0') ?? -1.0,
      holderName: dataModel['name']?.toParagraph().trim() ?? 'Not found',
      holderAddress: dataModel['address']?.toParagraph().trim() ?? 'Not found',
      dueDate: parsed,
    );
  }
}