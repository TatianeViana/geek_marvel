import 'package:flutter/material.dart';
import 'package:geek_marvel/cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geek_marvel/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geek_marvel/login_page.dart';

import 'home_page.dart';
class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validacoes dos textos digitados pelo usuarios,

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty) {
          setState(() {
            _mensagemErro = "";
          });
          Usuario usuario = Usuario();
          usuario.nome=nome;
          usuario.email=email;
          usuario.senha=senha;


          _cadastrarUsuario(usuario);
        } else {
          setState(() {
            _mensagemErro = "Preencha a senha!";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "e-mail inválido ";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }
  }

  _cadastrarUsuario( Usuario usuario ){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      // salvar dados do usuario firestore
      final user = FirebaseAuth.instance.currentUser!;

     FirebaseFirestore db = FirebaseFirestore.instance;
     db.collection('usuarios')
     .doc(user.uid);
      //.setData({usuario.toMap()});

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          )
      );

    }).catchError((error){
      print("erro app: " + error.toString() );
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Cadastro'),
      ),
      body: Container(

        decoration: BoxDecoration(color: Colors.grey[900]),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assets/image/deadpool.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'E-mail',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Create",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.deepPurpleAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(color: Colors.red, fontSize: 20),
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
