// ignore_for_file: invalid_use_of_visible_for_testing_member, implementation_imports

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_search_example/services/network/search_service/models/image_result.dart';
import 'package:image_search_example/services/network/search_service/models/search_response.dart';
import 'package:image_search_example/services/network/search_service/search_service.dart';
import 'package:rxdart/src/transformers/backpressure/throttle.dart';
import 'package:rxdart/src/transformers/flat_map.dart';


part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState.init()) {
    on<SearchLoadMoreEvent>(_addResults, transformer: throttle(const Duration(milliseconds: 1000)));
  }

  Future<void> _getResults() async {
    SearchResponse res = await SearchService.instance.search(
        query: state.query,
        offset: state.offset);
    if (res.error == null){
      List<ImageResult> irList = List.of(state.imageResults)..addAll(res.imageResults!);
      emit(state.copyWith(
          imageResults: irList,
          loading: false,
          loadingMore: false,
          noMoreResults: (res.imageResults?.length ?? 0) < 100,
          error: false));
    } else {
      emit(state.copyWith(
          loading: false,
          loadingMore: false,
          error: true));
    }
  }

  void newSearchByByQuery(String query) {
    emit(SearchState.newSearchByQuery(query));
    _getResults();
  }

  void _addResults(SearchLoadMoreEvent event, Emitter<SearchState> emit) {
    if (!state.loadingMore && !state.loading && !state.noMoreResults) {
      emit(state.copyWith(offset: state.offset + 1, loadingMore: true, error: false));
      _getResults();
    }
  }

}
