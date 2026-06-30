enum SequentialPageAction {
  back,
  skip,
  completed,
}

class SequentialPageRequest {
  final SequentialPageAction action;
  final int? index;

  const SequentialPageRequest.back()
      : action = SequentialPageAction.back,
        index = null;

  const SequentialPageRequest.skip(this.index)
      : action = SequentialPageAction.skip;

  const SequentialPageRequest.completed(this.index)
      : action = SequentialPageAction.completed;

  bool get isBack => action == SequentialPageAction.back;
  bool get isSkip => action == SequentialPageAction.skip;
  bool get isCompleted => action == SequentialPageAction.completed;
}