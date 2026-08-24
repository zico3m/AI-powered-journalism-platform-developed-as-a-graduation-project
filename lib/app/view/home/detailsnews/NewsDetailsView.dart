import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import '../../../controller/TTS/TtsController.dart';
import '../../../controller/favorites/news_favorite_controller.dart';
import '../../../controller/share/sharenews.dart';
import '../../../models/data/datamodles/news/NewsModel.dart';
import '../../../core/app_colors.dart';

class NewsDetailsView extends StatelessWidget {
  final NewsModel news;
  final RxDouble textScaleFactor = 1.0.obs;

  NewsDetailsView({
    super.key,
    required this.news,
  });

  void _increaseFontSize() {
    if (textScaleFactor.value < 1.5) textScaleFactor.value += 0.1;
  }

  void _decreaseFontSize() {
    if (textScaleFactor.value > 0.8) textScaleFactor.value -= 0.1;
  }

  void _resetFontSize() {
    textScaleFactor.value = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    final NewsTtsController ttsController =
        Get.put(NewsTtsController(), tag: 'tts_${news.id}');

    final timeAgo = news.publishedAt != null
        ? timeago.format(news.publishedAt!, locale: 'ar')
        : '';

    final isBreaking = news.isBreakingUntil != null &&
        news.isBreakingUntil!.isAfter(DateTime.now());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColor.darkBackground : AppColor.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// ───────── Sliver AppBar ─────────
            SliverAppBar(
              expandedHeight: screenHeight * 0.4,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: _buildBackButton(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Image
                    if (news.primaryImageUrl != null &&
                        news.primaryImageUrl!.isNotEmpty)
                      Image.network(
                        news.primaryImageUrl!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.35),
                        colorBlendMode: BlendMode.darken,
                      )
                    else
                      Container(
                        color: AppColor.primary.withOpacity(0.2),
                        child: Icon(
                          Icons.article_rounded,
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

                    /// Breaking badge
                    if (isBreaking)
                      Positioned(
                        top: 100,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.flash_on,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                "خبر عاجل",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    /// Source info
                    Positioned(
                      bottom: 20,
                      right: 20,
                      left: 20,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: news.source?.logoUrl != null
                                ? NetworkImage(news.source!.logoUrl!)
                                : null,
                            child: news.source?.logoUrl == null
                                ? Icon(Icons.public, color: AppColor.primary)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news.source?.name ?? "نبأ",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "Cairo",
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timeAgo,
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
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkCardBackground
                      : AppColor.cardBackground,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Category
                    if (news.categoryName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          news.categoryName!,
                          style: TextStyle(
                            color: AppColor.primary,
                            fontFamily: "Cairo",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// Title
                    Obx(() => Text(
                          news.title,
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 22 * textScaleFactor.value,
                            fontWeight: FontWeight.w800,
                            height: 1.4,
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.textPrimary,
                          ),
                        )),

                    const SizedBox(height: 20),

                    /// Tools
                    /// اختيار الصوت

                    /// Tools
                    _buildToolsRow(context, ttsController),

                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    /// Font size controls
                    _buildFontControls(context),

                    const SizedBox(height: 20),

                    /// Content
                    Obx(() => Text(
                          news.content,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 16 * textScaleFactor.value,
                            height: 1.8,
                            color: isDark
                                ? AppColor.darkTextSecondary
                                : AppColor.textSecondary,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ───────── UI Helpers ─────────

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child:
            const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildFontControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "حجم الخط",
          style: TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _decreaseFontSize,
            ),
            Obx(() => Text(
                  "${(textScaleFactor.value * 100).toInt()}%",
                  style: const TextStyle(fontFamily: "Cairo"),
                )),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _increaseFontSize,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetFontSize,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolsRow(BuildContext context, NewsTtsController ttsController) {
    final favController =
        Get.put(NewsFavoriteController(news.id), tag: 'fav_${news.id}');
    final NewsController newsController = Get.put(NewsController());


    return Row(
      children: [
        Expanded(
          child: _tool(
            Icons.auto_awesome,
            "تلخيص",
            Colors.purple,
            () => _showSummary(context, news.content),
          ),
        ),
        Expanded(
          child: Obx(() => _tool(
                ttsController.isPlaying.value ? Icons.stop : Icons.headphones,
                ttsController.isPlaying.value ? "إيقاف" : "استماع",
                Colors.green,
                () async {
                  if (ttsController.isPlaying.value) {
                    await ttsController.stop();
                  }

                  _showVoicePicker(context, ttsController);
                },
              )),
        ),
        Expanded(
          child: Obx(() => _tool(
                favController.isSaved.value
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                favController.isSaved.value ? "محفوظ" : "حفظ",
                Colors.orange,
                favController.toggleSave,
              )),
        ),
        Expanded(
          child: _tool(
            Icons.share,
            "مشاركة",
            Colors.blue,
            () {
              newsController.shareNews(
                title: news.title,
                description: news.content,
                url: news.categoryName,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showVoicePicker(
    BuildContext context,
    NewsTtsController ttsController,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "اختر الصوت",
                style: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _voiceItem("فهد", "fahad", ttsController),
              _voiceItem("سلطان", "sultan", ttsController),
              _voiceItem("لولوة", "lulwa", ttsController),
              _voiceItem("نورة", "noura", ttsController),
              _voiceItem("عائشة", "aisha", ttsController),
            ],
          ),
        );
      },
    );
  }

  Widget _voiceItem(
    String name,
    String value,
    NewsTtsController ttsController,
  ) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(fontFamily: "Cairo"),
      ),
      onTap: () async {
        ttsController.selectedVoice.value = value;

        Get.back(); // اغلاق BottomSheet

        await ttsController.play(news.content);
      },
    );
  }

  Widget _tool(IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// ───────── Summary ─────────

  Future<void> _showSummary(BuildContext context, String content) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/"
          "gemini-2.5-flash:generateContent?key=AIzaSyBWvnlwPZ8TLKFo_DMY2a1e40F-pbTHg2E",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "لخص الخبر  التالي  في ثلاث افكار كل فكرة 3 أسطر فقط  بدون إضافة رأي شخصي:\n$content"
                }
              ]
            }
          ]
        }),
      );

      Get.back();

      final data = jsonDecode(response.body);
      final summary = data["candidates"]?[0]?["content"]?["parts"]?[0]
              ?["text"] ??
          "لا يوجد ملخص";

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.purple),
                  const SizedBox(width: 8),
                  const Text(
                    "ملخص الخبر",
                    style: TextStyle(
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    summary,
                    style: const TextStyle(
                      fontFamily: "Cairo",
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Get.back();
      Get.defaultDialog(
        title: "خطأ",
        middleText: "حدث خطأ غير متوقع",
      );
    }
  }
}
