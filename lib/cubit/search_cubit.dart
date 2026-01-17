import 'dart:convert';
import 'package:chatbot/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../database/db_helper.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  List<Map<String, dynamic>> chatList = [];

  Future<void> loadChats() async {
    final data = await ChatDB.fetchChats();
    chatList = data.map((e) {
      return {
        "role": e['role'],
        "parts": [
          {"text": e['message']},
        ],
      };
    }).toList();
    emit(SearchLoadedState(res: ""));
  }

  void getSearchResponse({required String query}) async {
    emit(SearchLoadingState());

    chatList.add({
      "role": "user",
      "parts": [
        {"text": query},
      ],
    });

    await ChatDB.insertChat("user", query);

    const apiKey = "AIzaSyA2UmlpSOjoWcAB7pPd_bKyUd6cyVyuiwM";
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({"contents": chatList}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final res = data['candidates'][0]['content']['parts'][0]['text'];

      chatList.add({
        "role": "model",
        "parts": [
          {"text": res},
        ],
      });

      await ChatDB.insertChat("model", res);

      emit(SearchLoadedState(res: res));
    } else {
      emit(SearchErrorState(error: "Error ${response.statusCode}"));
    }
  }
}
