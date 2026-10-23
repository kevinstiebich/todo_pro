import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i12_into_012/models/todo.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default([]) List<Todo> todos,
    @Default(true) bool isDarkMode,
    @Default(true) bool asksForDeletionConfirmation,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default({})
    Set<String> selectedTodoIds,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
