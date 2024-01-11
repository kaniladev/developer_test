import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/post_bloc/post_bloc.dart';

class AddNotePage extends StatelessWidget {
  AddNotePage({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  labelText: 'Content',
                  floatingLabelAlignment: FloatingLabelAlignment.start),
            ),
            const SizedBox(height: 16),
            BlocProvider(
              create: (context) => PostBloc(),
              child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return state.when(
                    initial: () => ElevatedButton(
                          onPressed: () async {
                            addNote(context);
                          },
                          child: const Text('Save Note'),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                    loaded: (post) => ElevatedButton(
                          onPressed: () async {
                          },
                          // onPressed: saveDetails,
                          child: const Text('Hey Note'),
                        ),
                    error: () => ElevatedButton(
                        onPressed: () {}, child: const Text('Tap to retry')));
              },
            ),
            ),
          ],
        ),
      ),
    );
  }

  void addNote(BuildContext context) {

    try {
      final title = titleController.text;
      final content = contentController.text;

      context.read<PostBloc>().add(PostEvent.addNote(title: title, content: content));
    } finally {
      // TODO
      titleController.clear();
      contentController.clear();
    }

  }
}
