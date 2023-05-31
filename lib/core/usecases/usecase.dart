import '../failures/failures.dart';
import '../result/result.dart';
import 'params.dart';

abstract class UseCase<R, P extends Params> {
  Future<Result<Failure, R>> call(P params);
}

class NoParams extends Params {}