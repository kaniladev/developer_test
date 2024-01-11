import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/post.dart';
part 'post_event.dart';
part 'post_state.dart';
part 'post_bloc.freezed.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState.initial()) {
    on<Started>((event, emit) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool resultCon = await InternetConnection().hasInternetAccess;

      try {
        emit(const PostState.loading());
        if (resultCon) {
          const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
          final uri = Uri.parse(url);
          final response = await http.get(uri);

          if (response.statusCode == 200) {
            final json = jsonDecode(response.body) as Map;
            String saveData = jsonEncode(json);
            await prefs.setString('jsonData', saveData);
            String? jsonString = prefs.getString('jsonData');
            Map<String, dynamic> retrieveMap = jsonDecode(jsonString!);
            final result = retrieveMap['items'] as List;
            final List<Post> post =
                result.map((e) => Post.fromJson(e)).toList();
            emit(PostState.loaded(post));
          }
        } else {
          String? jsonString = prefs.getString('jsonData');
          Map<String, dynamic> retrieveMap = jsonDecode(jsonString!);
          final result = retrieveMap['items'] as List;
          final List<Post> post = result.map((e) => Post.fromJson(e)).toList();
          emit(PostState.loaded(post));
        }
      } catch (e) {
        emit(const PostState.error());
      }
    });

    on<FetchNote>((event, emit) async {
      try {
        emit(const PostState.loading());
        var url = 'https://api.nstack.in/v1/todos/${event.id}';
        final uri = Uri.parse(url);
        final response =
            await http.get(uri, headers: {'Content-type': 'application/json'});
        if (response.statusCode == 200) {
          List<Post> post = [];
          final json = jsonDecode(response.body);
          final Map<String, dynamic> result = json['data'];
          Post value = Post.fromJson(result);
          post.add(value);
          emit(PostState.loaded(post));
        } else {
          emit(const PostState.error());
        }
      } catch (e) {
        emit(const PostState.error());
      }
    });

    on<AddNote>((event, emit) async {
      final body = {
        "title": event.title,
        "description": event.content,
      };
      try {
        emit(const PostState.loading());
        const url = 'https://api.nstack.in/v1/todos';
        final uri = Uri.parse(url);
        final response = await http.post(uri,
            body: jsonEncode(body),
            headers: {"Content-Type": "application/json"});

        if (response.statusCode == 201) {
          emit(const PostState.initial());
        } else {
          emit(const PostState.error());
        }
      } catch (e) {
        emit(const PostState.error());
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        emit(const PostState.loading());
        var url = "https://api.nstack.in/v1/todos/${event.id}";
        final uri = Uri.parse(url);
        final response = await http
            .delete(uri, headers: {'Content-type': 'application/json'});
        if (response.statusCode == 200) {
          emit(const PostState.loading());
        } else {
          emit(const PostState.error());
        }
      } catch (e) {
        emit(const PostState.error());
      }
    });

    on<UpdateNote>((event, emit) async {
      final body = {
        "title": event.title,
        "description": event.content,
      };
      try {
        emit(const PostState.loading());
        final url = 'https://api.nstack.in/v1/todos/${event.id}';
        final uri = Uri.parse(url);
        final response = await http.put(uri, body: jsonEncode(body), headers: {
          "Content-Type": "application/json",
        });

        if (response.statusCode == 200) {
          emit(const PostState.initial());
        } else {
          emit(const PostState.error());
        }
      } catch (e) {
        emit(const PostState.error());
      }
    });
  }
}
