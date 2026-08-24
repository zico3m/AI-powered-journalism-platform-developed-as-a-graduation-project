// lib/app/widgets/DetailsPageTemplate.dart

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailsPageTemplate extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String content;

  final String authorOrSourceName;
  final String? authorOrSourceImageUrl;
  final DateTime? publishedAt;
  final int newsId;

  final VoidCallback onPlayAudio;
  final VoidCallback onSummarize;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  const DetailsPageTemplate({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.authorOrSourceName,
    required this.authorOrSourceImageUrl,
    required this.publishedAt,
    required this.newsId,
    required this.onPlayAudio,
    required this.onSummarize,
    required this.onShare,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final String timeAgo = publishedAt != null
        ? timeago.format(publishedAt!, locale: 'ar')
        : 'غير محدد';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black, blurRadius: 6),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                background: Hero(
                  tag: "news_image_$newsId",
                  child: Image.network(
                    imageUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🔹 معلومات الكاتب والمصدر
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: authorOrSourceImageUrl != null
                              ? NetworkImage(authorOrSourceImageUrl!)
                              : null,
                          child: authorOrSourceImageUrl == null
                              ? const Icon(Icons.person, size: 28)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorOrSourceName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo"),
                            ),
                            Text(
                              timeAgo,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontFamily: "Cairo"),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 أزرار الأدوات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _toolButton(Icons.play_circle_outline, "تشغيل", onPlayAudio),
                        _toolButton(Icons.summarize_outlined, "تلخيص", onSummarize),
                        _toolButton(Icons.share_outlined, "مشاركة", onShare),
                        _toolButton(Icons.favorite_border, "مفضلة", onFavorite),
                      ],
                    ),

                    const Divider(height: 35, thickness: 1),

                    // 🔹 عنوان كبير
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 🔹 نص المحتوى
                    Text(
                      content,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: "Cairo",
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontFamily: "Cairo"),
          )
        ],
      ),
    );
  }
}
