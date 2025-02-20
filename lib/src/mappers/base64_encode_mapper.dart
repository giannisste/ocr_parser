import 'dart:convert';

import 'mapper.dart';

class Base64EncodeMapper implements Mapper<List<int>, String> {
  @override
  String map(List<int> dataModel) => base64Encode(dataModel);
}
