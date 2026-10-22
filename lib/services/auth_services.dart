import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final _googleSignIn = GoogleSignIn();

Future<UserCredential?> signInWithGoogle() async{
  try{
  final GoogleSignInAccount? googleUser =await _googleSignIn.signIn();
  if (googleUser==null) return null;
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential =GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return FirebaseAuth.instance.signInWithCredential(credential);
}catch(e){
    return null;
  }

}

}