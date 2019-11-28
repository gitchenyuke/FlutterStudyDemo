import 'package:flutter/material.dart';

class NewsListEntity {
  int id;
  String title;
  String summary;

  NewsListEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    summary = json['summary'];
  }
}

class NewsEntity {
  List<NewsListEntity> news = [];

  NewsEntity.fromJson(Map<String, dynamic> json) {
    List list = json['news'];
    list.forEach((f) {
      news.add(NewsListEntity.fromJson(f));
    });
  }
}
