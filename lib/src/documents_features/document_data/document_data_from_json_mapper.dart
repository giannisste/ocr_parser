import '../../core/mappers/mapper.dart';
import '../../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import '../cosmote/cosmote_document.dart';
import '../dei/dei_document.dart';
import '../eydap/eydap_document.dart';
import '../nova/nova_document.dart';
import '../ocr_parsed_document/ocr_parsed_document.dart';
import 'document_data.dart';

class DocumentDataFromJsonMapper implements Mapper<OcrParsedDocument, DocumentData> {
  const DocumentDataFromJsonMapper({
    required this.deiMapper,
    required this.eydapMapper,
    required this.cosmoteMapper,
    required this.novaMapper,
  });

  final Mapper<Map<String, OcrParagraph?>, DeiDocument> deiMapper;
  final Mapper<Map<String, OcrParagraph?>, EydapDocument2025> eydapMapper;
  final Mapper<Map<String, OcrParagraph?>, CosmoteDocument> cosmoteMapper;
  final Mapper<Map<String, OcrParagraph?>, NovaDocument> novaMapper;

  @override
  DocumentData map(OcrParsedDocument dataModel) {
    return dataModel.documentFormat.fold(
      (deiDocumentFormat) =>
          DocumentData.deiDocument(deiMapper.map(dataModel.paragraphMap)),
      (eydapDocumentFormat) =>
          DocumentData.eydapDocument(eydapMapper.map(dataModel.paragraphMap)),
      (cosmoteDocumentFormat) => 
          DocumentData.cosmoteDocument(cosmoteMapper.map(dataModel.paragraphMap)),
      (novaDocumentFormat) => 
          DocumentData.novaDocument(novaMapper.map(dataModel.paragraphMap)),
      );
  }
}
