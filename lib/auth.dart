import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
    
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
    
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
    
      assert(!user!.isAnonymous);
    
      final User? currentUser = _auth.currentUser;
      assert(currentUser!.uid == user!.uid);
    
      print("auth------------------------------------------------------");
      print(user);
      return user;
    }
    
    return null; // User cancelled Google Sign-In
  } catch (error) {
    print("Error signing in with Google: $error");
    return null;
  }
}

void signOutGoogle() async {
  try {
    await googleSignIn.signOut();
    print("Google Sign-Out Successful");
  } catch (error) {
    print("Error signing out from Google: $error");
  }
}
