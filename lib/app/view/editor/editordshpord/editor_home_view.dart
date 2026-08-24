// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/editor/mange/editor_home_controller.dart';
// import '../../../controllers/notifications/notifications_controller.dart';
// import '../../notifications/notifications_view.dart';
// import '../../../routes/app_pages.dart';
// import '../../widgets/editore/editor_news_card.dart';
//
// class EditorHomeView extends StatelessWidget {
//   EditorHomeView({super.key});
//
//   final EditorHomeController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFD),
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: const Color(0xFF6366F1),
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.1),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications,color: Colors.white,),
//             onPressed: () {
//               Get.to(() => NotificationsView());
//             },
//           ),
//
//           const SizedBox(width: 8),
//
//           IconButton(
//             icon: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.logout,
//                 color: Colors.white,
//                 size: 22,
//               ),
//             ),
//             onPressed: () {
//               Get.offAllNamed(AppRoutes.login);
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Get.toNamed(AppRoutes.createNews);
//         },
//         backgroundColor: const Color(0xFF6366F1),
//         foregroundColor: Colors.white,
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         icon: const Icon(Icons.add_circle, size: 24),
//         label: const Text(
//           'خبر جديد',
//           style: TextStyle(fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.loading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'جاري تحميل البيانات...',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return RefreshIndicator(
//           color: const Color(0xFF6366F1),
//           onRefresh: () async {
//             // Add refresh logic here if needed
//           },
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Welcome Section
//                 const SizedBox(height: 24),
//
//                 // Stats Section
//
//                 // const SizedBox(height: 12),
//                 // _statsSection(),
//                 // const SizedBox(height: 32),
//
//                 // News Section Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'إحصائياتك',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1F2937),
//                       ),
//                     ),
//
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEEF2FF),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '${controller.news.length} خبر',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF6366F1),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 // News List
//                 controller.news.isEmpty
//                     ? Container(
//                   padding: const EdgeInsets.all(40),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.grey[200]!,
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.article_outlined,
//                         size: 64,
//                         color: Colors.grey[300],
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'لا توجد أخبار بعد',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'ابدأ بإنشاء أول خبر لك',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[500],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           Get.toNamed(AppRoutes.createNews);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF6366F1),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.add, size: 20),
//                             SizedBox(width: 8),
//                             Text('إنشاء خبر جديد'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : Column(
//                   children: controller.news.map((item) {
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: EditorNewsCard(
//                         news: item,
//                         onPreview: () {
//                           Get.toNamed('/news-preview', arguments: item);
//                         },
//                         onEdit: () {
//                           Get.toNamed('/edit-news',
//                               arguments: item['id']);
//                         },
//                         onDelete: () {
//
//
//
//
//                           _confirmDelete(context, item['id']);
//
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 100), // Space for FAB
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   // ================= helpers =================
//
//
//
//   void _confirmDelete(BuildContext context, int newsId) {
//     final reasonCtrl = TextEditingController();
//
//     Get.defaultDialog(
//       title: 'طلب حذف الخبر',
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('اكتب سبب الحذف بالتفصيل:'),
//           const SizedBox(height: 8),
//           TextField(
//             controller: reasonCtrl,
//             maxLines: 4,
//             decoration: const InputDecoration(
//               hintText: 'مثال: الخبر يحتوي معلومات غير دقيقة...',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//       textCancel: 'إلغاء',
//       textConfirm: 'إرسال للإدارة',
//       confirmTextColor: Colors.white,
//       onConfirm: () async {
//         final reason = reasonCtrl.text.trim();
//
//          controller.requestDeleteNews(newsId: newsId, reason: reason);
//         Get.back(); // close dialog
//       },
//     );
//   }
//
//
//
//   // void _confirmDelete(BuildContext context, int newsId) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return Directionality(
//   //         textDirection: TextDirection.rtl,
//   //         child: AlertDialog(
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(20),
//   //           ),
//   //           title: Column(
//   //             children: [
//   //               Container(
//   //                 width: 60,
//   //                 height: 60,
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.red.withOpacity(0.1),
//   //                   borderRadius: BorderRadius.circular(30),
//   //                 ),
//   //                 child: const Icon(
//   //                   Icons.delete_outline,
//   //                   color: Colors.red,
//   //                   size: 30,
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 16),
//   //               const Text(
//   //                 'تأكيد الحذف',
//   //                 style: TextStyle(
//   //                   fontWeight: FontWeight.w600,
//   //                   fontSize: 18,
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //           content: const Text(
//   //             'هل أنت متأكد من حذف هذا الخبر؟\nلا يمكن التراجع عن هذا الإجراء.',
//   //             textAlign: TextAlign.center,
//   //             style: TextStyle(
//   //               fontSize: 14,
//   //               color: Colors.grey,
//   //             ),
//   //           ),
//   //           actions: [
//   //             Row(
//   //               children: [
//   //                 Expanded(
//   //                   child: OutlinedButton(
//   //                     onPressed: () => Get.back(),
//   //                     style: OutlinedButton.styleFrom(
//   //                       foregroundColor: Colors.grey[600],
//   //                       padding: const EdgeInsets.symmetric(vertical: 12),
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(12),
//   //                       ),
//   //                       side: BorderSide(color: Colors.grey[300]!),
//   //                     ),
//   //                     child: const Text('إلغاء'),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(width: 12),
//   //                 Expanded(
//   //                   child: ElevatedButton(
//   //                     onPressed: () {
//   //                       controller.deleteNews(newsId);
//   //                       Get.back();
//   //                     },
//   //                     style: ElevatedButton.styleFrom(
//   //                       backgroundColor: Colors.red,
//   //                       foregroundColor: Colors.white,
//   //                       padding: const EdgeInsets.symmetric(vertical: 12),
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(12),
//   //                       ),
//   //                       elevation: 0,
//   //                     ),
//   //                     child: const Text('حذف'),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//   Widget _statsSection() {
//     return Row(
//       children: [
//         Expanded(child: _statCard(
//           title: 'كل أخباري',
//           value: controller.total.toString(),
//           icon: Icons.article,
//           color: const Color(0xFF6366F1),
//         )),
//         const SizedBox(width: 12),
//         Expanded(child: _statCard(
//           title: 'منشور',
//           value: controller.published.toString(),
//           icon: Icons.check_circle,
//           color: Colors.green,
//         )),
//         const SizedBox(width: 12),
//         Expanded(child: _statCard(
//           title: 'قيد المراجعة',
//           value: controller.pending.toString(),
//           icon: Icons.hourglass_top,
//           color: Colors.orange,
//         )),
//       ],
//     );
//   }
//
//   Widget _statCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: Colors.grey[100]!,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/editor/mange/editor_home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';
import '../../notifications/NotificationsView.dart';

class EditorHomeView extends StatelessWidget {
  EditorHomeView({super.key});

  final EditorHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6366F1),
        title: const Text(
          'أخباري',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Get.to(() => NotificationsView()),
          ),
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: Colors.white, size: 22),
            ),
            onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.createNews),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle, size: 24),
        label: const Text('خبر جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // شريط الإحصائيات (حسب حالة الأخبار)
            _StatsBar(),
            const SizedBox(height: 16),

            // شريط البحث والتصفية
            _SearchAndFilterBar(),
            const SizedBox(height: 16),

            // قائمة الأخبار
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final news = controller.filteredNews;

                if (news.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text('لا توجد أخبار تطابق بحثك',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final item = news[index];
                    return _NewsCard(item: item, controller: controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ويدجتس مساعدة ---

class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditorHomeController>();
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
                label: 'منشور',
                count: controller.published.value,
                color: Colors.green),
            // _StatItem(
            //     label: 'قيد المراجعة',
            //     count: controller.pending.value,
            //     color: Colors.orange),
            // _StatItem(
            //     label: 'مرفوض',
            //     count: controller.rejected.value,
            //     color: Colors.red),
            _StatItem(
                label: 'الإجمالي',
                count: controller.total.value,
                color: Colors.blue),
          ],
        ));
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatItem(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditorHomeController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'بحث في عناوين الأخبار...',
                    border: InputBorder.none,
                  ),
                  onChanged: controller.onSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('الحالة:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Obx(() => DropdownButton<String>(
                    value: controller.statusFilter.value,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('الكل')),
                      DropdownMenuItem(
                          value: 'published', child: Text('منشور')),
                      DropdownMenuItem(
                          value: 'pending', child: Text('قيد المراجعة')),
                      DropdownMenuItem(value: 'rejected', child: Text('مرفوض')),
                    ],
                    onChanged: controller.onStatusFilter,
                  )),
              const SizedBox(width: 16),
              const Text('طلب حذف:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Obx(() => DropdownButton<String>(
                    value: controller.requestFilter.value,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('الكل')),
                      DropdownMenuItem(
                          value: 'has_pending_request',
                          child: Text('لديه طلب pending')),
                    ],
                    onChanged: controller.onRequestFilter,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// بطاقة الخبر (مشابهة لـ AdminNewsCard مع إضافة معلومات الطلب)
class _NewsCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final EditorHomeController controller;

  const _NewsCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final String title = (item['title'] ?? 'بدون عنوان').toString();
    final String status = (item['status'] ?? '').toString();
    final String? imageUrl = item['primary_image']?.toString();
    final source = item['sources'] is Map
        ? Map<String, dynamic>.from(item['sources'])
        : null;
    final category = item['categories'] is Map
        ? Map<String, dynamic>.from(item['categories'])
        : null;
    final String sourceName = (source?['name'] ?? 'نبأ').toString();
    final String categoryName = (category?['name'] ?? 'بدون تصنيف').toString();

    // بيانات طلب الحذف إن وجد
    final deleteRequest = item['delete_request'] as Map<String, dynamic>?;
    final hasPendingRequest =
        deleteRequest != null && deleteRequest['status'] == 'pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported)),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _InfoChip(text: categoryName, color: Colors.blue),
                          const SizedBox(width: 8),
                          Flexible(
                              child: _InfoChip(
                                  text: sourceName, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasPendingRequest) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'طلب حذف pending: ${deleteRequest!['reason']}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.cancel, size: 16, color: Colors.red),
                      onPressed: () =>
                          _confirmCancelRequest(context, deleteRequest['id']),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(status: status),
                Row(
                  children: [
                    if (!hasPendingRequest && status != 'rejected')
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 20),
                        onPressed: () =>
                            _showDeleteRequestDialog(context, item['id']),
                        tooltip: 'طلب حذف',
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteRequestDialog(BuildContext context, int newsId) {
    final reasonCtrl = TextEditingController();

    Get.defaultDialog(
      title: 'طلب حذف الخبر',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('اكتب سبب الحذف بالتفصيل:'),
          const SizedBox(height: 8),
          TextField(
            controller: reasonCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'مثال: الخبر يحتوي معلومات غير دقيقة...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textCancel: 'إلغاء',
      textConfirm: 'إرسال للإدارة',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final reason = reasonCtrl.text.trim();
        controller.requestDeleteNews(newsId: newsId, reason: reason);
        Get.back(); // close dialog
      },
    );
  }

  void _confirmCancelRequest(BuildContext context, int requestId) {
    Get.defaultDialog(
      title: 'إلغاء الطلب',
      middleText: 'هل أنت متأكد من إلغاء طلب الحذف هذا؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.cancelDeleteRequest(requestId);
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late final String text;
    late final Color color;

    switch (status) {
      case 'published':
        text = 'منشور';
        color = Colors.green;
        break;
      case 'pending':
        text = 'قيد المراجعة';
        color = Colors.orange;
        break;
      case 'rejected':
        text = 'مرفوض';
        color = Colors.red;
        break;
      default:
        text = status;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  final Color color;
  const _InfoChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
