import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import 'legal_page_controller.dart';

class LegalPageView extends GetView<LegalPageController> {
  final String pageKey;

  const LegalPageView({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    controller.loadPage(pageKey);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.page.value == null) {
          return _buildErrorState();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContentCard(context),
                    if (pageKey == 'about') ...[
                      const SizedBox(height: 32),
                      _buildSocialSection(),
                      const SizedBox(height: 32),
                      _buildContactSection(),
                      const SizedBox(height: 40),
                      _buildFooter(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- States ---

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(_getPrimaryColor()),
          ),
          const SizedBox(height: 24),
          Text(
            'جاري تحميل المحتوى...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            const Text(
              'عذراً، تعذر تحميل البيانات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'يرجى التأكد من اتصالك بالإنترنت والمحاولة مرة أخرى',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.loadPage(pageKey),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPrimaryColor(),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSliverAppBar(BuildContext context) {
    final primaryColor = _getPrimaryColor();
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16),
        title: Text(
          controller.page.value?.title ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Center(
              child: Opacity(
                opacity: 0.2,
                child: Icon(_getPageIcon(), size: 100, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageDescriptionHeader(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1),
          ),
          MarkdownBody(
            data: controller.page.value!.content,
            styleSheet: _buildMarkdownStyle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPageDescriptionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getPrimaryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(_getPageIcon(), color: _getPrimaryColor(), size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نظرة عامة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getPrimaryColor(),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getPageDescriptionText(),
                style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تواصل معنا عبر',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildSocialCard(
              icon: Icons.facebook_rounded,
              label: 'فيسبوك',
              color: const Color(0xFF1877F2),
              url: 'https://facebook.com',
            ),
            _buildSocialCard(
              icon: Icons.alternate_email_rounded,
              label: 'تويتر (X)',
              color: const Color(0xFF000000),
              url: 'https://twitter.com',
            ),
            _buildSocialCard(
              icon: Icons.camera_alt_rounded,
              label: 'انستجرام',
              color: const Color(0xFFE4405F),
              url: 'https://instagram.com',
            ),
            _buildSocialCard(
              icon: Icons.play_circle_fill_rounded,
              label: 'يوتيوب',
              color: const Color(0xFFFF0000),
              url: 'https://youtube.com',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialCard({
    required IconData icon,
    required String label,
    required Color color,
    required String url,
  }) {
    return InkWell(
      onTap: () => print('فتح: $url'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildContactItem(Icons.email_outlined, 'البريد الإلكتروني', 'zico2001s@yahoo.com'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
          _buildContactItem(Icons.phone_android_rounded, 'رقم الهاتف', '+967738959023'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
          _buildContactItem(Icons.location_on_outlined, 'الموقع', 'اليمن'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 20, color: Colors.blueGrey[700]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 24),
        Text(
          '© 2026 جميع الحقوق محفوظة',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
          child: Text(
            'الإصدار 2.1.0',
            style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // --- Helpers ---

  Color _getPrimaryColor() {
    switch (pageKey) {
      case 'privacy_policy':
        return const Color(0xFF2E7D32);
      case 'terms_of_service':
        return const Color(0xFF1565C0);
      case 'about':
        return const Color(0xFFEF6C00);
      default:
        return const Color(0xFF455A64);
    }
  }

  IconData _getPageIcon() {
    switch (pageKey) {
      case 'privacy_policy':
        return Icons.verified_user_rounded;
      case 'terms_of_service':
        return Icons.gavel_rounded;
      case 'about':
        return Icons.rocket_launch_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _getPageDescriptionText() {
    switch (pageKey) {
      case 'privacy_policy':
        return 'نلتزم بحماية بياناتك وخصوصيتك بأعلى المعايير الأمنية.';
      case 'terms_of_service':
        return 'القواعد والشروط التي تحكم استخدامك لمنصتنا وخدماتنا.';
      case 'about':
        return 'تعرف على قصتنا، رؤيتنا، والقيم التي نبني عليها مستقبلنا.';
      default:
        return 'معلومات قانونية وتفاصيل حول المنصة.';
    }
  }

  MarkdownStyleSheet _buildMarkdownStyle(BuildContext context) {
    final primaryColor = _getPrimaryColor();
    return MarkdownStyleSheet(
      h1: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor, height: 1.6),
      h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.6),
      p: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.7),
      listBullet: TextStyle(color: primaryColor, fontSize: 16),

      blockquotePadding: const EdgeInsets.all(16),
      blockSpacing: 16,
    );
  }
}
