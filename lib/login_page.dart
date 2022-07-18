import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geek_marvel/model/Usuario.dart';
import 'package:geek_marvel/main.dart';

import 'cadastro.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos(){

    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@") ){

      if( senha.isNotEmpty ){

        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario( usuario );


      }else{
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha o E-mail utilizando @";
      });
    }

  }



  _logarUsuario( Usuario usuario ){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          )
      );

    }).catchError((error){

      setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });

    });

  }

  Future _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();


    User? usuarioLogado = await auth.currentUser;

    if( usuarioLogado != null ){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          )
      );
    }

  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(

        //decoration: BoxDecoration(color: Color(0xff14213a)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset("assets/image/shield.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20,),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20,),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16,bottom:10 ),
                  child: RaisedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                    color: Colors.deepPurpleAccent,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      _validarCampos();
                    }),
                  ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Don't have account?Create!",
                      style: TextStyle(
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>Cadastro()
                          )
                      );
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red,
                          fontSize: 20),
                    ),
                  ),
                )

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

