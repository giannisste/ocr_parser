import '../../core_types/either/either.dart';
import '../dei/dei_document.dart';
import '../eydap/eydap_document.dart';

class DocumentData {
  const DocumentData(this.either);

  factory DocumentData.deiDocument(DeiDocument deiDocument) => DocumentData(Either.left(deiDocument));
  factory DocumentData.eydapDocument(EydapDocument2025 eydapDocument) =>
      DocumentData(Either.right(eydapDocument));

  final Either<DeiDocument, EydapDocument2025> either;

  S fold<S>(
    S Function(DeiDocument) deiDocumentFunction,
    S Function(EydapDocument2025) eydapDocumentFunction,
  ) =>
      either.fold(deiDocumentFunction, eydapDocumentFunction);
}
