import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_colors.dart';

class NewsCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String sourceName;
  final String? sourceLogoUrl;
  final String timeAgo;
  final String? categoryName;
  final bool isBreaking;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final bool isSaved;

  const NewsCard({
    super.key,
    required this.title,
    required this.sourceName,
    required this.timeAgo,
    this.imageUrl,
    this.sourceLogoUrl,
    this.categoryName,
    this.isBreaking = false,
    this.onFavorite,
    this.onShare,
    this.onTap,
    required this.isSaved,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovering) {
    if (mounted) {
      setState(() => _isHovering = isHovering);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg =
    isDark ? AppColor.darkCardBackground : AppColor.cardBackground;
    final textPrimary =
    isDark ? AppColor.darkTextPrimary : AppColor.textPrimary;
    final textSecondary =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.15),
                  blurRadius: _isHovering ? 25 : 15,
                  spreadRadius: _isHovering ? 2 : 1,
                  offset: Offset(0, _isHovering ? 8 : 4),
                ),
              ],
              border: Border.all(
                color: textSecondary.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Image
                  if (widget.imageUrl != null)
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColor.primary.withOpacity(0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl!,
                            fit: BoxFit.cover,
                            memCacheHeight: 400,
                            placeholder: (_, __) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primary,
                              ),
                            ),
                            errorWidget: (_, __, ___) => Icon(
                              Icons.newspaper_rounded,
                              size: 60,
                              color: textSecondary,
                            ),
                          ),
                        ),

                        /// Breaking badge
                        if (widget.isBreaking)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade600,
                                    Colors.red.shade800,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.warning_amber_rounded,
                                      size: 14, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    "عاجل",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: "Cairo",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        /// Category
                        if (widget.categoryName != null)
                          Positioned(
                            top: widget.isBreaking ? 56 : 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.categoryName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Cairo",
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text(
                          widget.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            fontFamily: "Cairo",
                            color: textPrimary,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Time
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 14, color: textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              widget.timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                                fontFamily: "Cairo",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// Source
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: textSecondary.withOpacity(0.3),
                                ),
                              ),
                              child: ClipOval(
                                child: widget.sourceLogoUrl != null &&
                                    widget.sourceLogoUrl!.startsWith('http')
                                    ? Image.network(
                                  widget.sourceLogoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.public_rounded,
                                          color: AppColor.primary),
                                )
                                    : Icon(Icons.newspaper_rounded,
                                    color: AppColor.primary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.sourceName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                                fontFamily: "Cairo",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// Divider
                        Container(
                          height: 1,
                          color: textSecondary.withOpacity(0.15),
                        ),

                        const SizedBox(height: 16),

                        /// Actions
                        Row(
                          children: [
                            _buildInteractionButton(
                              icon: Icons.share_rounded,
                              label: 'sharing'.tr,
                              onTap: widget.onShare,
                              color: isDark ? AppColor.background : AppColor.primary,
                              textSecondary: textSecondary,
                            ),
                            const SizedBox(width: 20),
                            _buildInteractionButton(
                              icon: widget.isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              label: widget.isSaved
                                  ? 'محفوظ'
                                  : 'save'.tr,
                              onTap: widget.onFavorite,
                              color: widget.isSaved
                                  ? Colors.amber
                                  : AppColor.primary,
                              textSecondary: textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
    required Color textSecondary,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Icon(icon, size: 20, color: color),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textSecondary,
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
