import 'mapper.dart';

class ListMapper<From, To> implements Mapper<List<From>, List<To>> {
  ListMapper(this._mapper);

  final Mapper<From, To> _mapper;

  @override
  List<To> map(List<From> domainModel) =>
      domainModel.map(_mapper.map).toList();

}
