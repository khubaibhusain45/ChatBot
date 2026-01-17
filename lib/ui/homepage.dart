import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot/cubit/search_cubit.dart';
import 'package:chatbot/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class HOMEPAGE extends StatefulWidget {
  const HOMEPAGE({super.key});

  @override
  State<HOMEPAGE> createState() => _HOMEPAGEState();
}

class _HOMEPAGEState extends State<HOMEPAGE> {
  var search = TextEditingController();
  Future<String>? resp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("ChatBot App"),
          centerTitle: true,
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          elevation: 7,
          shadowColor: Colors.purple,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 18, right: 12, left: 12, bottom: 20),
          child: Column(
            children: [
              TextField(
                controller: search,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text("Search"),
                  prefixIcon: Icon(Icons.search),
                  hintText: "What's in your mind today?",
                ),
              ),
              SizedBox(height: 11),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                    elevation: 11,
                    shadowColor: Colors.purple,
                  ),
                  onPressed: () {
                    if (search.text.isNotEmpty) {
                      context.read<SearchCubit>().getSearchResponse(
                        query: search.text,
                      );
                    }
                  },
                  label: Text("Search"),
                  icon: Icon(Icons.search_outlined),
                ),
              ),
              SizedBox(height: 21),
              // GptMarkdown used for proper text formatting
              Expanded(
                child: BlocConsumer<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is SearchLoadedState) {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: GptMarkdown(
                          state.res,
                          style: TextStyle(fontSize: 17),
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  },
                  listener: (context, state) {
                    if (state is SearchErrorState) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
