import 'package:chat_bot/chat/model/message.dart';
import 'package:chat_bot/chat/presentation/chat_bubble.dart';
import 'package:chat_bot/chat/presentation/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  //


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea (
        child: Column(
          children: [
            //Top section: Chat masseage
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child){
                  // empty
                  if (chatProvider.messages.isEmpty) {
                    return const Center(
                      child: Text("Start a convo.."),
                    );
                  }
        
                  // chat message
                  return ListView.builder(
                    itemCount: chatProvider.messages.length, 
                    itemBuilder: (context, index) {
                        //Get each Message
                        final message = chatProvider.messages[index];
        
                        //Return message
                        return ChatBubble(message: message);
                    },
                  );
                },
              ),
            ),
              // Loading Indicator
              Consumer <ChatProvider>(
                builder: (context, chatProvider, child){
                  if (chatProvider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox();
                },
              ),
             // User input box
             Row(
              children: [
                // LEFT -> Text box
                Expanded(
                  child: TextField(controller: _controller), 
                ),
        
               // RIGHT -> Send but button
               IconButton(
                onPressed: () {
                  if(_controller.text.isNotEmpty){
                    final chatProvider = context.read<ChatProvider>();
                    chatProvider.sendMessage(_controller.text);
                    _controller.clear();
                  }
                },
                icon: const Icon(Icons.send),
        
               )
              ],            
             ),
          ],
        ),
      ),
    );
  }
}