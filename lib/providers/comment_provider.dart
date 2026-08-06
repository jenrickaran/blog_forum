import 'package:flutter/material.dart';
import 'package:flutter_app/models/comment.dart';
import 'package:flutter_app/services/comment_service.dart';
import 'package:image_picker/image_picker.dart';

class CommentProvider extends ChangeNotifier {
  final CommentService _commentService = CommentService();

  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _stackTrace;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get stackTrace => _stackTrace;

  /// Load all comments for a post
  Future<void> loadComments(int postId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _comments = await _commentService.getComments(postId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a comment
  Future<bool> createComment({
    required int postId,
    required String content,
    List<XFile> images = const [],
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _commentService.createComment(
        postId: postId,
        content: content,
        images: images,
      );

      await loadComments(postId);
      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
      _stackTrace = stackTrace.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update a comment
  Future<bool> updateComment({
    required int commentId,
    required int postId,
    required String content,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _commentService.updateComment(
        commentId: commentId,
        content: content,
      );

      await loadComments(postId);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a comment
  Future<bool> deleteComment({
    required int commentId,
    required int postId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _commentService.deleteComment(commentId);

      await loadComments(postId);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear local comments
  void clearComments() {
    _comments.clear();
    notifyListeners();
  }
}
