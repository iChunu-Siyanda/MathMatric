import 'package:flutter/material.dart';

class TabPages {
  static Map<String,List<Widget>> otherTabPages = {
    "streak":[],
    "progress_score":[],
    "class_notes":[],
    "practice_papers":[],
  };

  void dates(){
    for (int i = 2019; i < 2025; i++) {
      i.toString();
    }
  }

  static Map<String,Map<String,List<Widget>>> paperTabPages = {
    "March":{},
    "June":{},
    "November":{},
    "IEB":{}
  };
}
