
import '../../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import '../../core/mappers/mapper.dart';
import 'nova_document.dart';

class NovaDocumentFromJsonMapper implements Mapper<Map<String, OcrParagraph?>, NovaDocument> {
  const NovaDocumentFromJsonMapper(this.amountMapper);

  final Mapper<String, double?> amountMapper;

  @override
  NovaDocument map(Map<String, OcrParagraph?> dataModel) {
    DateTime? parsed;
    try {
      final date = dataModel['dueDate']?.toParagraph().trim() ?? '';
      final parts = date.split('/').map(int.parse).toList();
      parsed = DateTime(parts[2], parts[1], parts[0]);
    } catch (e) {
      parsed = null;
    }
    return NovaDocument(
      rfCode: dataModel['rfCode']?.toParagraph().trim() ?? 'Not found',
      paymentAmount: amountMapper.map(dataModel['totalAmount']?.toParagraph() ?? '-1.0') ?? 0.0,
      holderAddress: dataModel['address']?.toParagraph().trim() ?? 'Not found',
      holderName: 'holderName',
      dueDate: parsed,
    );
  }
}
