import 'package:ocr_parser/src/google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';

import '../../mappers/mapper.dart';
import 'dei_document.dart';

class DeiDocumentFromJsonMapper implements Mapper<Map<String, OcrParagraph?>, DeiDocument> {
  const DeiDocumentFromJsonMapper(this.amountMapper);

  final Mapper<String, double?> amountMapper;

  @override
  DeiDocument map(Map<String, OcrParagraph?> dataModel) {
    DateTime? parsed;
    try {
      final date = dataModel['dueDate']?.toParagraph().trim() ?? '';
      final parts = date.split('/').map(int.parse).toList();
      parsed = DateTime(parts[2], parts[1], parts[0]);
    } catch (e) {
      parsed = null;
    }
    return DeiDocument(
      rfCode: dataModel['rfCode']?.toParagraph().trim() ?? 'Not found',
      paymentAmount: amountMapper.map(dataModel['totalAmount']!.toParagraph()) ?? -1.0,
      address: dataModel['address']?.toParagraph().trim() ?? 'Not found',
      dueDate: parsed,
    );
  }
}

class AmountMapper implements Mapper<String, double?> {
  @override
  double? map(String dataModel) {
    final sanitizedInput = dataModel.replaceAll(',', '.');
    final regex = RegExp(r'[-+]?\d*\.?\d+');
    final Match? match = regex.firstMatch(sanitizedInput);
    return match != null ? double.tryParse(match.group(0)!) : null;
  }
}
