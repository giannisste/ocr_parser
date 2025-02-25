import '../../bounding_box_method_features/bounding_box_map/bounding_box_map.dart';
import '../../core/core_types/usecases/usecase.dart';
import '../document_format/document_format.dart';

class GetDocumentBoundingBoxMapUsecase
    implements Usecase<BoundingBoxMap, DocumentFormat> {
  const GetDocumentBoundingBoxMapUsecase({
    required this.getDeiBoundingBoxMapUsecase,
    required this.getEydapBoundingBoxMapUsecase,
    required this.getCosmoteBoundingBoxMapUsecase,
    required this.getNovaBoundingBoxMapUsecase,
  });

  final Usecase<BoundingBoxMap, DeiDocumentFormat> getDeiBoundingBoxMapUsecase;
  final Usecase<BoundingBoxMap, EydapDocumentFormat>
  getEydapBoundingBoxMapUsecase;
  final Usecase<BoundingBoxMap, CosmoteDocumentFormat>
  getCosmoteBoundingBoxMapUsecase;
  final Usecase<BoundingBoxMap, NovaDocumentFormat>
  getNovaBoundingBoxMapUsecase;

  @override
  Future<BoundingBoxMap> execute(DocumentFormat event) {
    return event.fold(
      getDeiBoundingBoxMapUsecase.execute,
      getEydapBoundingBoxMapUsecase.execute,
      getCosmoteBoundingBoxMapUsecase.execute,
      getNovaBoundingBoxMapUsecase.execute,
    );
  }
}
