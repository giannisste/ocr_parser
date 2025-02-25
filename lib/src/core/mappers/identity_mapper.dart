import 'mapper.dart';

class IdentityMapper<D> implements Mapper<D, D> {
  @override
  D map(D domainModel) => domainModel;
}
