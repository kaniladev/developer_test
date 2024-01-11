import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/post_bloc/post_bloc.dart';

class NotePage extends StatefulWidget {
  final String id;

  const NotePage({super.key, required this.id});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  late String newTitle;
  late String newContent;
  TextEditingController contentController = TextEditingController();
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            BlocProvider(
              create: (context) => PostBloc(),
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      TextButton(onPressed: () async {
                        deleteNote(context);
                      }, child: const Text("Delete")),
                      TextButton(onPressed: edit ? () async {

                        updateNote(context);
                      } : null, child: const Text("Save")),
                    ],
                  );
                },
              ),
            )
          ],
        ),
        body: BlocProvider(
          create: (context) => PostBloc(),
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state,) {
              return state.when(
                  initial: () {
                    context.read<PostBloc>().add(PostEvent.fetchNote(id: widget.id));
                    return const Center(child: CircularProgressIndicator(),);
                  },
                  loading: () =>
                  const Center(child: CircularProgressIndicator(),),
                  error: () =>
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Tap to retry')),
                  loaded: (post) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          TextFormField(
                            onChanged: (value){
                              setState(() {
                                edit = post[0].title == value ? false : true;
                                newTitle = post[0].title == value ? post[0].title : value;
                              });
                            },
                              decoration: const InputDecoration(
                                  label: Text('Title')
                              ),
                              initialValue: post[0].title),
                          const SizedBox(height: 15,),
                          TextFormField(
                              onChanged: (value){
                                setState(() {
                                  edit = post[0].content == value ? false : true;
                                  newContent = post[0].content == value ? post[0].content : value;
                                });
                              },
                              decoration: const InputDecoration.collapsed(hintText: 'Details'
                              ),
                              maxLines: 10,
                              initialValue: post[0].content),
                        ],
                      ),
                    );
                  });
            },
          ),
        )
    );
  }

  void updateNote(BuildContext context) {

    final title = newTitle;
    final content = newContent;

    context.read<PostBloc>().add(PostEvent.updateNote(id: widget.id, title: title, content: content));

    Navigator.pop(context);
  }

  void deleteNote(BuildContext context) {
    context.read<PostBloc>().add(PostEvent.deleteNote(id: widget.id));

    Navigator.pop(context);
  }
}
