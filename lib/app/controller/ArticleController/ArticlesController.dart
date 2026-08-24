import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/datamodles/artical/ArticleModel.dart';
import '../../models/data/services/SupabaseService.dart';
import '../../models/data/services/artical_repo/article_repository.dart';
import '../../models/data/services/comment/CommentRepository.dart';

class ArticleController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;
  final ArticleRepository _repo = ArticleRepository();
final CommentRepository _repo_forcmment = CommentRepository();

  final articles = <ArticleModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  final commentsCount = <int, int>{}.obs;
  final likesCount = <int, int>{}.obs;

  // ================= Articles =================

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await _repo.fetchPublishedArticles();

      articles.assignAll(
        data.map((e) => ArticleModel.fromJson(e)).toList(),
      );

      for (final article in articles) {
        await loadCommentsCount(article.id!);
      }
    } catch (e) {
      error.value = "فشل في جلب المقالات";
      debugPrint("FETCH ARTICLES ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyArticles() async {
    try {
      isLoading.value = true;
      error.value = null;

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        articles.clear();
        return;
      }

      final data = await _repo.fetchMyArticles(userId);

      articles.assignAll(
        data.map((e) => ArticleModel.fromJson(e)).toList(),
      );

      for (final article in articles) {
        await loadCommentsCount(article.id!);
        await loadLikesCount(article.id!);
      }
    } catch (e) {
      error.value = "فشل في جلب منشوراتك";
      debugPrint("FETCH MY ARTICLES ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> loadCommentsCount(int articleId) async {
    commentsCount[articleId] = await _repo_forcmment.fetchCommentsCount(articleId);
  }

  Future<void> loadLikesCount(int articleId) async {
    likesCount[articleId] = await _repo.fetchLikesCount(articleId);
  }

  Future<void> deleteArticle(int articleId) async {
    await _repo.deleteArticle(articleId);
    articles.removeWhere((a) => a.id == articleId);
  }

  Future<void> updateArticle({
    required int articleId,
    required String title,
    required String content,
  }) async {
    await _repo.updateArticle(
      articleId: articleId,
      title: title,
      content: content,
    );

    final index = articles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      articles[index] = articles[index].copyWith(
        title: title,
        content: content,
      );
    }
  }
}
