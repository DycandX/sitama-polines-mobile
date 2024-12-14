import 'package:flutter/material.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? userName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<AuthProvider>(context);
    userName = authProvider.userName;
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 20, 20), // Padding atas dan bawah
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align items to the right
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 10, 20), // Mengurangi padding kiri
            child: Container(
              constraints: BoxConstraints(maxWidth: 150), // Atur lebar maksimum
              child: Text(
                userName ?? "Loading...",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w100,
                  color: Colors.black,
                ),
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
    );
  }
}
