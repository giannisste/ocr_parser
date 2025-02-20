import '../../core_types/either/either.dart';
import '../document_data/document_data.dart';

typedef DocumentResponse = Either<DocumentData, String>;
