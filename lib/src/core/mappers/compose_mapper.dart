import '../extensions/compose_extension.dart';

import 'mapper.dart';

class ComposeMapper<A, B, C> implements Mapper<A, C> {
  const ComposeMapper(this.firstMapper, this.secondMapper);

  final Mapper<A, B> firstMapper;
  final Mapper<B, C> secondMapper;

  @override
  C map(A dataModel) {
    final composedMapper = secondMapper.map.compose(firstMapper.map);
    return composedMapper(dataModel);
  }
}
