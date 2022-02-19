part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState._(
      {this.query = "",
      this.offset = 0,
      this.imageResults = const [],
      this.loadingMore = false,
      this.loading = false,
      this.noMoreResults = false,
      this.error = false});

  const SearchState.init() : this._();

  const SearchState.newSearchByQuery(String query) : this._(query: query, loading: true);

  SearchState copyWith(
      {String? query,
      int? offset,
      List<ImageResult>? imageResults,
      bool? loadingMore,
      bool? loading,
      bool? noMoreResults,
      bool? error}) {
    return SearchState._(
        query: query ?? this.query,
        offset: offset ?? this.offset,
        imageResults: imageResults ?? this.imageResults,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        noMoreResults: noMoreResults ?? this.noMoreResults,
        error: error ?? this.error);
  }

  final String query;
  final int offset;
  final bool loadingMore;
  final bool loading;
  final bool error;
  final bool noMoreResults;
  final List<ImageResult> imageResults;

  @override
  List<Object> get props => [
        loading,
        loadingMore,
        imageResults,
        offset,
        noMoreResults,
        error,
      ];
}
