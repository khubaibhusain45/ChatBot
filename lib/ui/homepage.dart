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
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().loadChats();
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ChatBot"),
          centerTitle: true,
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<SearchCubit, SearchState>(
                listener: (_, __) => scrollDown(),
                builder: (context, state) {
                  final cubit = context.read<SearchCubit>();

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: cubit.chatList.length +
                        (state is SearchLoadingState ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == cubit.chatList.length) {
                        // Loading bubble
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final msg = cubit.chatList[index];
                      final isUser = msg['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.purple : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: isUser
                              ? Text(
                            msg['parts'][0]['text'],
                            style: const TextStyle(color: Colors.white),
                          )
                              : GptMarkdown(msg['parts'][0]['text']),
                        ),
                      );
                    },
                  );

                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.purple),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        context.read<SearchCubit>().getSearchResponse(
                          query: controller.text,
                        );
                        controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
