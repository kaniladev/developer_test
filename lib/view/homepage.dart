import 'package:developer_test/controller/post_bloc/post_bloc.dart';
import 'package:developer_test/view/add_note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  getPost(){
    context.read<PostBloc>().add(const PostEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Simple Notes'),
        ),
        body: BlocBuilder<PostBloc, PostState>(
            builder: (BuildContext context, state) {
              return state.when(initial: () {
                getPost();
                return const Center(
                    child: CircularProgressIndicator());
              },
                loading: () =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
                error: () =>
                    ElevatedButton(onPressed: () {
                      getPost();
                    }, child: const Text('Tap to retry')),
                loaded: (post) =>
                    RefreshIndicator(
                      onRefresh: () async {
                        getPost();
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: post.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              navigateToNotePage(post[index].id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                color: Colors.blueGrey[50],
                                child: ListTile(
                                  leading: const Icon(Icons.arrow_right),
                                  title: Text(post[index].title),
                                ),
                              ),
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 5,),
                      ),
                    ),);
            }),
        floatingActionButton: ElevatedButton(
          onPressed: navigateToAddNotePage,
          child: const Text('Add note'),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
      );
  }

  void navigateToAddNotePage() {
    final route = MaterialPageRoute(builder: (context) => AddNotePage());
    Navigator.push(context, route);
  }

  void navigateToNotePage(id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NotePage(id: id);
    }));
  }
}