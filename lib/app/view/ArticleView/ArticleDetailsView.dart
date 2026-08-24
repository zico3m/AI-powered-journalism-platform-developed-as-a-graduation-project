import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ArticleController/article_details_controller.dart';
import '../../core/app_colors.dart';
import '../../models/data/datamodles/artical/ArticleModel.dart';
import '../Comments/comment_dialog.dart';
import '../reporet_articleveiw/report_dialog.dart';

class ArticleDetailsView extends StatefulWidget {
  final ArticleModel article;
  final int? highlightCommentId;

  const ArticleDetailsView({
    super.key,
    required this.article,
    this.highlightCommentId,
  });

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ArticleDetailsController(widget.article.id!),
      tag: 'details_${widget.article.id}',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        isDark ? AppColor.darkBackground : AppColor.background,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// ───────── Sliver AppBar ─────────
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: _circleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Get.back(),
                isDark: isDark,
              ),
              actions: [
                _circleButton(
                  icon: Icons.share_outlined,
                  onTap: () {},
                  isDark: isDark,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Cover Image
                    if (widget.article.coverImage != null)
                      Image.network(
                        widget.article.coverImage!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.35),
                        colorBlendMode: BlendMode.darken,
                      )
                    else
                      Container(
                        color: AppColor.primary.withOpacity(0.2),
                        child: Icon(
                          Icons.article_outlined,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),

                    /// Bottom gradient
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              isDark
                                  ? AppColor.darkBackground
                                  : AppColor.background,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Author info
                    Positioned(
                      bottom: 20,
                      right: 20,
                      left: 20,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            backgroundImage:
                            widget.article.author.pictureUrl != null
                                ? NetworkImage(
                                widget.article.author.pictureUrl!)
                                : null,
                            child:
                            widget.article.author.pictureUrl == null
                                ? Icon(Icons.person,
                                color: AppColor.primary)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.article.author.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Cairo",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _timeAgo(widget.article.createdAt),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontFamily: "Cairo",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ───────── Content ─────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 20, bottom: 16),
                      child: Text(
                        widget.article.title,
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.4,
                          color: isDark
                              ? AppColor.darkTextPrimary
                              : AppColor.textPrimary,
                        ),
                      ),
                    ),

                    /// Stats
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _cardDecoration(isDark),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(
                              icon: Icons.favorite_outline,
                              value:
                              controller.likesCount.value.toString(),
                              label: "إعجاب",
                            ),
                            _statItem(
                              icon: Icons.chat_bubble_outline,
                              value: controller.commentsCount.value
                                  .toString(),
                              label: "تعليق",
                            ),
                          ],
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    /// Content
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: _cardDecoration(isDark),
                      child: Text(
                        widget.article.content,
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 16,
                          height: 1.8,
                          color: isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Interaction Bar
                    Container(
                      height: 70,
                      decoration: _cardDecoration(isDark),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          _actionBtn(
                            icon: controller.isLiked.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            label: "إعجاب",
                            onTap: controller.toggleLike,
                          ),
                          _actionBtn(
                            icon: Icons.chat_bubble_outline,
                            label: "تعليق",
                            onTap: () {
                              showCommentsDialog(
                                  context, widget.article.id!);
                            },
                          ),
                          _actionBtn(
                            icon: Icons.share_outlined,
                            label: "مشاركة",
                            onTap: () {},
                          ),
                          _actionBtn(
                            icon: Icons.flag_outlined,
                            label: "بلاغ",
                            color: Colors.red,
                            onTap: () {
                              showReportDialog(
                                  context, widget.article.id!);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── Helpers ─────────

  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
    color: isDark
        ? AppColor.darkCardBackground
        : AppColor.cardBackground,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.black.withOpacity(0.45)
            : Colors.white.withOpacity(0.9),
      ),
      child: IconButton(
        icon: Icon(icon,
            color: isDark ? Colors.white : Colors.black),
        onPressed: onTap,
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColor.primary.withOpacity(0.15),
          child: Icon(icon, color: AppColor.primary),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(
                fontFamily: "Cairo", fontSize: 12)),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? AppColor.primary;

    return Column(
      children: [
        Material(
          color: c.withOpacity(0.15),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap, // ✅ عاد التفاعل
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                icon,
                color: c,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Cairo",
            fontSize: 11,
          ),
        ),
      ],
    );
  }


  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
    return 'منذ ${(diff.inDays / 30).floor()} شهر';
  }
}

