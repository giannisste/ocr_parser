import '../../core/core_types/core_2d/point/point.dart';
import '../../core/mappers/mapper.dart';
import 'ocr_bounding_box.dart';

class OcrBoundingBoxMapper implements Mapper<Map<String, dynamic>, OcrBoundingBox> {
  const OcrBoundingBoxMapper({required this.verticesMapper});

  final Mapper<List<Map<String, dynamic>>, List<Point<double>>> verticesMapper;
  @override
  OcrBoundingBox map(Map<String, dynamic> dataModel) {
    final verticesJson = (dataModel['vertices'] as List).cast<Map<String, dynamic>>();
    final vertices = verticesMapper.map(verticesJson);
    return OcrBoundingBox(
      upperLeft: vertices[0],
      upperRight: vertices[1],
      bottomRight: vertices[2],
      bottomLeft: vertices[3],
    );
  }
}

class VertexMapper implements Mapper<Map<String, dynamic>, Point<double>> {
  @override
  Point<double> map(Map<String, dynamic> json) {
    final xCoord = json['x'];
    final yCoord = json['y'];
    return Point(
      x: xCoord != null ? (xCoord as int).toDouble() : 0.0,
      y: yCoord != null ? (yCoord as int).toDouble() : 0.0,
    );
  }
}
