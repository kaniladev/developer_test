import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post{
  const factory Post({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'description') required String content,
    required String title,
}) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}