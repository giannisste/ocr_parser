
import '../../core/core_types/either/either.dart';
import '../../core/core_types/predicates/predicate.dart';

class DocumentFormat {
  const DocumentFormat._(this.either4);
  factory DocumentFormat.dei(DeiDocumentFormat format) =>
      DocumentFormat._(Either4.first(format));
  factory DocumentFormat.eydap(EydapDocumentFormat format) =>
      DocumentFormat._(Either4.second(format));
  factory DocumentFormat.cosmote(CosmoteDocumentFormat format) =>
      DocumentFormat._(Either4.third(format));
  factory DocumentFormat.nova(NovaDocumentFormat format) =>
      DocumentFormat._(Either4.fourth(format));

  final Either4<
    DeiDocumentFormat,
    EydapDocumentFormat,
    CosmoteDocumentFormat,
    NovaDocumentFormat
  >
  either4;

  S fold<S>(
    S Function(DeiDocumentFormat) deiDocumentFunction,
    S Function(EydapDocumentFormat) eydapDocumentFunction,
    S Function(CosmoteDocumentFormat) cosmoteDocumentFunction,
    S Function(NovaDocumentFormat) novaDocumentFunction,
  ) => either4.fold(
    deiDocumentFunction,
    eydapDocumentFunction,
    cosmoteDocumentFunction,
    novaDocumentFunction,
  );
}

typedef DocumentFormatResponse = Either<DocumentFormat, UnknownDocumentFormat>;

class UnknownDocumentFormat {
  const UnknownDocumentFormat();
}

class DeiDocumentFormat {
  const DeiDocumentFormat();
}

class EydapDocumentFormat {
  const EydapDocumentFormat();
}

class NovaDocumentFormat {
  const NovaDocumentFormat();
}

class CosmoteDocumentFormat {
  const CosmoteDocumentFormat();
}

extension DocumentFormatExtension on String {
  DocumentFormatResponse foldDocumentFormat(
    Predicate<String> deiPredicate,
    Predicate<String> eydapPredicate,
    Predicate<String> cosmotePredicate,
    Predicate<String> novaPredicate,
  ) {
    if (deiPredicate.check(this)) {
      return DocumentFormatResponse.left(
        DocumentFormat.dei(const DeiDocumentFormat()),
      );
    } else if (eydapPredicate.check(this)) {
      return DocumentFormatResponse.left(
        DocumentFormat.eydap(const EydapDocumentFormat()),
      );
    } else if (cosmotePredicate.check(this)) {
      return DocumentFormatResponse.left(
        DocumentFormat.cosmote(const CosmoteDocumentFormat()),
      );
    } else if (novaPredicate.check(this)) {
      return DocumentFormatResponse.left(
        DocumentFormat.nova(const NovaDocumentFormat()),
      );
    } else {
      return DocumentFormatResponse.right(const UnknownDocumentFormat());
    }
  }
}
