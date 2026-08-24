// import 'package:flutter/material.dart';
//
//
// import '../newscard/NewsDetailView.dart';
// import '../newscard/newscard.dart';
//
// class MyInterestView extends StatelessWidget {
//    MyInterestView({super.key});
//
//   final List<NewsArticle> _articles =  [
//     NewsArticle(
//
//       id: 'interest_1',
//       title: 'هيكل خبر اهتمامات: كيف تطور عالم الرياضة الرقمية',
//       content: 'المحتوى الكامل عن الرياضات الرقمية...',
//       imageUrls: ['https://picsum.photos/seed/interest_1/800/600'],
//       source: 'مصدر رياضي',
//       publishedAt: DateTime.now(),
//       category: 'رياضة',
//     ),
//     NewsArticle(
//       id: 'interest_2',
//       title: 'هيكل خبر اهتمامات: أحدث ابتكارات التكنولوجيا',
//       content: 'المحتوى الكامل عن الابتكارات التكنولوجية...',
//       imageUrls: ['https://picsum.photos/seed/interest_2/800/600'],
//       source: 'مصدر تقني',
//       publishedAt: DateTime.now(),
//       category: 'تكنولوجيا',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: _articles.length,
//       itemBuilder: (context, index) {
//         final article = _articles[index];
//         return NewsCardWidget(
//           article: article,
//           onCardTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => NewsDetailView(article: article)),
//             );
//           },
//           onShareTap: () {
//             print("Share Tapped: ${article.title}");
//             // هنا تضع منطق مشاركة الخبر
//           },
//           onFavoriteTap: () {
//             print("Favorite Tapped: ${article.title}");
//             // هنا تستدعي دالة في الـ Controller لتغيير حالة المفضلة
//           },
//         );
//       },
//     );
//   }
// }
