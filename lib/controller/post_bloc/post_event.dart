part of 'post_bloc.dart';

@freezed
class PostEvent with _$PostEvent {
  const factory PostEvent.started() = Started;
  const factory PostEvent.fetchPost() = FetchPost;
  const factory PostEvent.fetchNote({required String id}) = FetchNote;
  const factory PostEvent.addNote({required String title, required String content}) = AddNote;
  const factory PostEvent.updateNote({required String id, required String title, required String content}) = UpdateNote;
  const factory PostEvent.deleteNote({required String id}) = DeleteNote;
}
