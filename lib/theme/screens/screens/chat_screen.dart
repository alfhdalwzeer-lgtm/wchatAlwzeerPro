import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import '../widgets/avatar_circle.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final controller =
      TextEditingController();

  final messages =
      <Map<String, dynamic>>[

    {
      'text':
          'السلام عليكم، مرحباً بك في الفهد',

      'time': '10:00 ص',

      'mine': false,
    },

    {
      'text':
          'وعليكم السلام! تطبيق ممتاز جداً.',

      'time': '10:01 ص',

      'mine': true,
    },
  ];

  void send() {

    final text =
        controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {

      messages.add({
        'text': text,
        'time': 'الآن',
        'mine': true,
      });

      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        leading: IconButton(

          icon:
              const Icon(Icons.arrow_back),

          onPressed: () =>
              Navigator.pop(context),
        ),

        titleSpacing: 0,

        title: const Row(

          children: [

            AvatarCircle(
              size: 48,
            ),

            SizedBox(width: 10),

            Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  'مستخدم الفهد',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  'متصل الآن',

                  style: TextStyle(
                    color:
                        Colors.greenAccent,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.phone,
              color: AppColors.gold,
            ),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(
              Icons.videocam,
              color: AppColors.gold,
            ),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.gold,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(

        children: [

          Expanded(

            child:
                ListView.builder(

              padding:
                  const EdgeInsets.only(
                top: 12,
              ),

              itemCount:
                  messages.length,

              itemBuilder: (_, i) {

                final m =
                    messages[i];

                return MessageBubble(

                  text: m['text'],

                  time: m['time'],

                  mine: m['mine'],
                );
              },
            ),
          ),

          SafeArea(

            top: false,

            child: Container(

              color:
                  AppColors.header,

              padding:
                  const EdgeInsets.fromLTRB(
                8,
                7,
                8,
                7,
              ),

              child: Row(

                children: [

                  IconButton(

                    icon:
                        const Icon(
                      Icons.image,
                      color:
                          AppColors.gold,
                    ),

                    onPressed: () {},
                  ),

                  Expanded(

                    child:
                        TextField(

                      controller:
                          controller,

                      textInputAction:
                          TextInputAction.send,

                      onSubmitted: (_) =>
                          send(),

                      style:
                          const TextStyle(
                        fontSize: 20,
                      ),

                      decoration:
                          const InputDecoration(
                        hintText:
                            'اكتب رسالة...',
                        border:
                            InputBorder.none,
                      ),
                    ),
                  ),

                  IconButton(

                    icon:
                        const Icon(
                      Icons.emoji_emotions_outlined,
                      color:
                          AppColors.gold,
                    ),

                    onPressed: () {},
                  ),

                  ValueListenableBuilder<
                      TextEditingValue>(

                    valueListenable:
                        controller,

                    builder:
                        (_, value, __) {

                      return IconButton(

                        icon: Icon(

                          value.text
                                  .trim()
                                  .isEmpty
                              ? Icons.mic
                              : Icons.send,

                          color:
                              AppColors.gold,
                        ),

                        onPressed:
                            value.text
                                    .trim()
                                    .isEmpty
                                ? () {}
                                : send,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
