import 'package:flutter/material.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/services/post_service.dart';
import 'package:image_picker/image_picker.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  String? _errorMessage;
  bool _isLoading = false;
  List<Post> _posts = [];

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<Post> get posts => _posts;

  Future<void> createPost({
    required String title,
    required String content,
    required List<XFile> images,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _postService.createPost(
        title: title,
        content: content,
        images: images,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPosts({bool loadMore = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      const pageSize = 10;

      final from = _posts.length;
      final to = from + pageSize - 1;

      final newPosts = await _postService.fetchPosts(from: from, to: to);

      if (loadMore) {
        _posts.addAll(newPosts);
      } else {
        _posts = newPosts;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePost(int postId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _postService.deletePost(postId);

      _posts.removeWhere((post) => post.id == postId);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePost({
    required int postId,
    required String title,
    required String content,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _postService.updatePost(
        postId: postId,
        title: title,
        content: content,
      );

      // Update local post list
      final index = _posts.indexWhere((post) => post.id == postId);

      if (index != -1) {
        _posts[index] = _posts[index].copyWith(title: title, content: content);
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
