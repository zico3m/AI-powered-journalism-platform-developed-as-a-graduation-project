import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/data/datamodles/news/NewsModel.dart';
import 'detailsnews/NewsDetailsView.dart';

class NewsDetailsLoader extends StatelessWidget {
  final int newsId;

  const NewsDetailsLoader({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Supabase.instance.client
          .from('news')
          .select(
          '''
            *,
            source:source_id (*)
            '''
      )
          .eq('id', newsId)
          .single(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final newsJson = snapshot.data as Map<String, dynamic>;
        final news = NewsModel.fromJson(newsJson);

        return NewsDetailsView(news: news);
      },
    );
  }












}
