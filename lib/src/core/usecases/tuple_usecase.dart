import 'package:ocr_parser/src/core/core_types/tuple/record_map_extension.dart';

import 'usecase.dart';

class TupleUsecase<T1, T2, E1, E2> implements Usecase<(T1, T2), (E1, E2)> {
  TupleUsecase(this._usecase1, this._usecase2);

  final Usecase<T1, E1> _usecase1;
  final Usecase<T2, E2> _usecase2;

  @override
  Future<(T1, T2)> execute((E1, E2) event) async {
    return event.asyncMap(_usecase1.execute, _usecase2.execute);
  }
}
