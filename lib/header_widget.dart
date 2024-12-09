import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String name;
  final String avatarPath;

  const HeaderWidget({
    Key? key,
    required this.name,
    required this.avatarPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(avatarPath),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
