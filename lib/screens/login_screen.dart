
import 'package:expense_tracker/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _authService= AuthService();
  String? _emailError;
  String? _passError;
  String? _generalError;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _showResetDialog(BuildContext context) {
    final _resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset password'),
        content: TextField(
          controller: _resetController,
          decoration: InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_resetController.text.isEmpty) return;
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: _resetController.text.trim(),
                );
                Navigator.pop(context);
                setState(() => _generalError = null);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reset email sent — check your inbox')),
                );
              } on FirebaseAuthException catch (e) {
                Navigator.pop(context);
                setState(() => _generalError = e.message ?? 'Failed to send reset email');
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
   body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white54, Colors.indigoAccent, Colors.white12],
          )
      ),
        child:
            SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15, // pushes content down
                      ),
              child:
      Column(

        children: [
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
              children: [
                const TextSpan(
                  text: 'Glass',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 6),
                    ],
                  ),
                ),
                const TextSpan(
                  text: 'Vault',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(color: Colors.lightBlue, blurRadius: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35,),
          Text('Welcome Back' , style: TextStyle(fontSize: 22),),
          const SizedBox(height: 35,),
          Container(
            padding: EdgeInsets.all(30),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(

          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
          ) ,
            child: Column(
              children: [
              TextField(
                onChanged: (val)=>setState(()=>_emailError=null) ,
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: _emailError,
                  label: Text('Email'),
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
              ),
                const SizedBox(height: 25,),
                TextField(
                  onChanged: (val)=>setState(()=>_passError=null) ,
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    errorText: _passError,
                      label: Text('Password'),
                      labelStyle: TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      )
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40,),
                SizedBox(width: double.infinity,
             child:   ElevatedButton(onPressed: () async {
                  if (_emailController.text.isEmpty || _passwordController.text.isEmpty){
                        setState(()=>_emailError='Email is required' );
                        setState(()=>_passError='Password is required' );
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim());
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                  on FirebaseAuthException catch (e) {
                 setState(()=>_generalError = e.message?? 'Login Failed');

                  }
                },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.black54,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                   padding: EdgeInsets.symmetric(vertical: 16)
                 ),
                    child: Text('Login' , style: TextStyle(color: Colors.white),)),),
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () => _showResetDialog(context),
                  child: Text('Forgot password?', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 20,),
                SizedBox(child: OutlinedButton.icon(onPressed:
                ()async{
                  final result =  await _authService.signInWithGoogle();
                  if(result !=null){
                    Navigator.pushReplacementNamed(context, '/home');
                  }else{
                    setState(()=>_generalError = 'Google sign in failed');
                  }
                },
                    icon: Icon(Icons.g_mobiledata),
                    label: Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),),),
                const SizedBox(height: 30,),
                if(_generalError!=null)
                  Padding(padding: EdgeInsets.only(top: 8) ,child: 
                    Text(_generalError! , style: TextStyle(color: Colors.red),),),
                TextButton(onPressed:(){
                  Navigator.pushNamed(context, '/signup');
                }, child: Text(" Don''t have an account? Signup" , ))
              ],
            ),
          )
              ],
      ),
      )
      )
    )));
  }
}
