import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/news_model.dart';

void openNewsDetail(BuildContext context, NewsModel news) {
  context.push('/news/${news.id}', extra: news);
}
