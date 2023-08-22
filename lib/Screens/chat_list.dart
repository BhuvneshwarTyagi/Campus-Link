import 'package:flutter/material.dart';
import 'chat.dart';

class chatsystem extends StatefulWidget {
  const chatsystem({super.key});

  @override
  State<chatsystem> createState() => _chatsystemState();
}

class _chatsystemState extends State<chatsystem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(63, 63, 63,1),

        title: const Text("Campus Link"),
      ),
      body: SizedBox(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const chat_page(),
                      ));
                },
                child: Container(
                  height: 90,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1))),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 20),
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(86, 149, 178, 1),
                          radius: 30,

                          child: Text("P",
                            style: TextStyle(color: Colors.black,fontSize: 30),

                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 28),
                        child: Text("Priyanka",
                          style: TextStyle(color: Colors.black,fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
        ),
      ),
    );
  }
}
