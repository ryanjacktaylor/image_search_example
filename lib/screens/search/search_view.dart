import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_search_example/bloc/search_bloc.dart';
import 'package:image_search_example/constants/app_colors.dart';
import 'package:image_search_example/screens/image/image_page.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void onSearchSubmitted(BuildContext context, String query) {
    context.read<SearchBloc>().newSearchByByQuery(query.trim());
    focusNode.unfocus();
  }

  void _scrollListener() {
    if (_isBottom) {
      context.read<SearchBloc>().add(SearchLoadMoreEvent());
      //context.read<SearchBloc>().addResults();
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey900,
      body: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        return SafeArea(
            child: Column(
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.only(left: 20),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                      ),
                      onEditingComplete: () {
                        onSearchSubmitted(context, _controller.text);
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        onSearchSubmitted(context, _controller.text);
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
            ),
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.imageResults.isEmpty
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Image Search', style: TextStyle(color: AppColors.white, fontSize: 24)),
                            Text(
                              'Enter a search term to begin',
                              style: TextStyle(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.count(
                            controller: scrollController,
                            crossAxisCount: 3,
                            children: List.generate(state.imageResults.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImagePage(imageUrl: state.imageResults[index].original)),
                                      );
                                    },
                                    child: Image.network(state.imageResults[index].thumbnail)),
                              );
                            }),
                          ),
                        ),
            ),
          ],
        ));
      }),
    );
  }
}
