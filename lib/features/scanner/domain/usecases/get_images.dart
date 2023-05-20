import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/scanner_repository_impl.dart';
import '../entities/scanner.dart';
import '../repositories/scanner_repository.dart';

@reflection
class GetImages extends UseCase<List<Scanner>, NoParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: ScannerRepositoryImpl)
  late ScannerRepository repository;

  GetImages() {
    super.inject();
  }

  @override
  Future<Result<Failure, List<Scanner>>> call(NoParams params) async {
    final response = await repository.getImages();
    return response.fold(
      (left) => Left(
        UseCaseFailure(message: "Não foi possível processar as imagens!")
      ),
      (right) => Right(right));
  }

  set setRepository(ScannerRepository repository) {
    this.repository = repository;
  }
}