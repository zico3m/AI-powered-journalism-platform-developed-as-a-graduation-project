import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../../core/app_colors.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String authorName;
  final ImageProvider<Object>? authorImage;
  final String timeAgo;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final int? likesCount;
  final int? commentsCount;
  final Color? cardColor;
  final BorderRadiusGeometry? borderRadius;
  final double? imageHeight;
  final bool showEngagementStats;
  final bool? isLiked;
  final Future<bool> Function(bool)? onLikeTapped;
  final bool? showOwnerActions;

  const ArticleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.authorName,
    required this.timeAgo,
    this.authorImage,
    this.onLike,
    this.onComment,
    this.likesCount,
    this.commentsCount,
    this.cardColor,
    this.borderRadius,
    this.imageHeight = 240,
    this.showEngagementStats = true,
    this.isLiked,
    this.onLikeTapped,
    this.showOwnerActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark
        ? AppColor.darkCardBackground
        : AppColor.cardBackground;

    final textPrimary =
    isDark ? AppColor.darkTextPrimary : AppColor.textPrimary;

    final textSecondary =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        borderRadius: borderRadius ?? BorderRadius.circular(28),
        color: cardColor ?? bg,
        elevation: 0,
        child: Column(
          children: [
            /// Image
            ClipRRect(
              borderRadius: borderRadius ??
                  const BorderRadius.vertical(top: Radius.circular(28)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primary,
                  ),
                ),
                errorWidget: (_, __, ___) => Icon(
                  Icons.photo_library_rounded,
                  size: 48,
                  color: textSecondary,
                ),
              ),
            ),

            /// Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(

                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Engagement + Author row
                  Row(
                    children: [

                      /// Author info
                      ///
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.primary.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: authorImage,
                          child: authorImage == null
                              ? Icon(Icons.person_rounded,
                              color: AppColor.primary)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 6),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            authorName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 12, color: textSecondary),
                              const SizedBox(width: 6),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),


                      /// Author avatar

                      const Spacer(),

                      if (showEngagementStats) ...[
                        _buildLikeButton(textSecondary),
                        const SizedBox(width: 16),
                        _buildCommentButton(textSecondary),
                      ],


                    ],
                  ),

                  if (showEngagementStats) ...[
                    const SizedBox(height: 20),
                    Divider(color: textSecondary.withOpacity(0.2)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ❤️ Like button (aligned with NewsCard)
  Widget _buildLikeButton(Color textSecondary) {
    return LikeButton(
      size: 26,
      isLiked: isLiked,
      likeCount: likesCount,
      onTap: onLikeTapped,
      likeBuilder: (isLiked) {
        return Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isLiked ? Colors.red : AppColor.primary,
        );
      },
      countBuilder: (count, isLiked, text) {
        if (count == null) return const SizedBox.shrink();
        return Text(
          _formatCount(count),
          style: TextStyle(
            fontSize: 12,
            color: isLiked ? Colors.red : textSecondary,
          ),
        );
      },
      circleColor: const CircleColor(
        start: Colors.red,
        end: Colors.redAccent,
      ),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.red,
        dotSecondaryColor: Colors.redAccent,
      ),
    );
  }

  /// 💬 Comment button (same visual language)
  Widget _buildCommentButton(Color textSecondary) {
    return IconButton(
      onPressed: onComment,
      icon: Icon(
        Icons.chat_bubble_outline_rounded,
        size: 24,
        color: AppColor.primary,
      ),
      splashRadius: 22,
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}م';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}ك';
    }
    return count.toString();
  }
}
