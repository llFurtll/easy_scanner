abstract class Result<L, R> {
  const Result();

  B fold<B>(B Function(L left) isLeft, B Function(R right) isRight);
}

class Right<L, R> extends Result<L, R> {
  final R _right;
  const Right(this._right);

  @override
  B fold<B>(B Function(L left) isLeft, B Function(R right) isRight) => isRight(_right);
}

class Left<L, R> extends Result<L, R> {
  final L _left;
  const Left(this._left);

  @override
  B fold<B>(B Function(L left) isLeft, B Function(R right) isRight) => isLeft(_left);
}