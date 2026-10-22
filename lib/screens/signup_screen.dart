import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white54 , Colors.indigoAccent  , Colors.white12 ]),
      ),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15, // pushes content down
                  ),
          child:
      Column(
mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Create an account' , style: TextStyle(fontSize: 22),),
          const SizedBox(height: 35,),

          Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withValues(alpha: 0.3))
          ),

            child: Column(

              children: [


                TextField(
                  onChanged:(val)=> setState(() =>_emailError = null),
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text('Email'),
                    errorText: _emailError,
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  onChanged: (val)=>setState(()=>_passError = null),
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text('Password'),
                    errorText: _passError,
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    )
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40,),
                SizedBox(width: double.infinity,
                    child:
                ElevatedButton(onPressed: () async{
                  final emailInput = _emailController.text.trim();
                  final passInput = _passwordController.text.trim();
                  if(_passwordController.text.isEmpty ||_emailController.text.isEmpty){
                        setState(()=>_passError = 'Password is required'  );
                        setState(()=>_emailError = 'Email is required'  );
                  return;
                  }

                  if(!_emailController.text.contains('@') || !_emailController.text.contains('.')){
                        setState(()=>_emailError='Enter a valid email address' );
                    return;
                  }
                  if(_passwordController.text.length<6){
                  setState(()=>_passError = 'Password should be more than 6 characters');
                    return;
                  }

                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailInput, password: passInput);
                    Navigator.pushReplacementNamed(context, '/home');
                  }on FirebaseAuthException catch (e){
                  setState(()=> _generalError = e.message ?? 'Sign Up Failed');

                  }
                },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15)),
                      backgroundColor: Colors.black54,
                      padding: EdgeInsets.symmetric(vertical: 16)
                    ),
                    child: Text('Sign Up' , style: TextStyle(color: Colors.white),))),
               if(_generalError!=null)
                Padding(padding:
               EdgeInsets.only(top: 8) , child: Text(_generalError! , style: TextStyle(color: Colors.red),),),
               const SizedBox(height: 30,),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/login');
                },
                    child: Text('Already have an account? Login'))
              ],
            ),
          )

        ],
      ),
      ))
    )));
  }
}
