import 'package:flutter/material.dart';
import 'profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 20, 20), // Tambah padding bawah
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Text(
                  profile.name,
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
                backgroundImage: AssetImage(profile.avatarPath),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
