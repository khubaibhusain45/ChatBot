import 'dart:convert';

import 'package:chatbot/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SearchCubit extends Cubit<SearchState> {
  static List<Map<String, dynamic>> chatList = [];

  SearchCubit() : super(SearchInitialState());

  // events
  void getSearchResponse({required String query}) async {
    emit(SearchLoadingState());

    chatList.add( {
      "role": "user",
      "parts": [
        {
          "text": query
        }
      ]
    },);

    String API_Key = "AIzaSyA2UmlpSOjoWcAB7pPd_bKyUd6cyVyuiwM";
    String URL =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$API_Key";
    Map<String, dynamic> bodyParams = {"contents": chatList};

    var response = await http.post(
      Uri.parse(URL),
      body: jsonEncode(bodyParams),
    );
    if (response.statusCode == 200) {
      // For taking accurate data required rather than keys
      var data = jsonDecode(response.body);
      var res =
          data['candidates'][0]["content"]["parts"][0]["text"]; // different for every API Key


      chatList.add( {
        "role": "model",
        "parts": [
          {
            "text": res
          }
        ]
      },);


      emit(SearchLoadedState(res: res));
    } else {
      var error = "Error ${response.statusCode}";
      emit(SearchErrorState(error: error));
    }
  }
}
