
part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent([this._props]);

  final List<Object>? _props;

  @override
  List<Object?> get props => _props ?? [];
}

class SearchLoadMoreEvent extends SearchEvent {}

EventTransformer<SearchLoadMoreEvent> throttle<SearchLoadMoreEvent>(Duration duration) {
  return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
}
