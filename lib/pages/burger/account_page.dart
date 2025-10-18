import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order_up_app/backend/firebase/database_service.dart';
import 'package:order_up_app/components/misc/app_colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    Future<void> clickedSendEmail() async {
      try {
        await auth.sendPasswordResetEmail(email: user!.email!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent!')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error sending reset email')),
        );
      }
    }

    return FutureBuilder(future: DatabaseService().getUsername(uid: (user?.uid)!), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userName = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.maroonColor, foregroundColor: AppColors.whiteColor,
            ),
            body: Center(
              child: SizedBox(
                width: 412,
                height: 917,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 18, bottom: 16),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                                      width: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("Email: ", style: TextStyle(fontSize: 18),),
                                Text(
                                  "${user?.email}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),

                            Row(
                              children: [
                                Text("Account Creation: ", style: TextStyle(fontSize: 18),),
                                Text(
                                  "${user?.metadata.creationTime!.month}-${user?.metadata.creationTime!.day}-${user?.metadata.creationTime!.year}",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 42, bottom: 42),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 161, 24, 29),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: clickedSendEmail,
                                child: const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),

                            Center(child: Opacity(opacity: 0.7, child: Image.asset('img/orderuplogo.png', width: 320)))                     
                          ],
                        ),
                      ),
                    ),

                    // Nav Bar //
                  
                  ],
                ),
              ),
            ),
          );
        }
    });
  }
}
