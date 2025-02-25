import '../../core/core_types/either/either.dart';
import '../cosmote/cosmote_document.dart';
import '../dei/dei_document.dart';
import '../eydap/eydap_document.dart';
import '../generic_document/generic_document.dart';
import '../nova/nova_document.dart';

class DocumentData {
  const DocumentData(this.either);

  factory DocumentData.deiDocument(DeiDocument deiDocument) =>
      DocumentData(Either5.first(deiDocument));
  factory DocumentData.eydapDocument(EydapDocument2025 eydapDocument) =>
      DocumentData(Either5.second(eydapDocument));
  factory DocumentData.cosmoteDocument(CosmoteDocument cosmoteDocument) =>
      DocumentData(Either5.third(cosmoteDocument));
  factory DocumentData.novaDocument(NovaDocument novaDocument) =>
      DocumentData(Either5.fourth(novaDocument));
factory DocumentData.genericDocument(GenericDocument genericDocument) =>
      DocumentData(Either5.fifth(genericDocument));

  final Either5<DeiDocument, EydapDocument2025, CosmoteDocument, NovaDocument, GenericDocument>
  either;

  S fold<S>(
    S Function(DeiDocument) deiDocumentFunction,
    S Function(EydapDocument2025) eydapDocumentFunction,
    S Function(CosmoteDocument) cosmoteDocumentFunction,
    S Function(NovaDocument) novaDocumentFunction,
    S Function(GenericDocument) genericDocumentFunction,
  ) => either.fold(
    deiDocumentFunction,
    eydapDocumentFunction,
    cosmoteDocumentFunction,
    novaDocumentFunction,
    genericDocumentFunction
  );
}

