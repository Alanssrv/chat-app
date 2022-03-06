import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  AuthForm({required this.onSubmit, Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final _authFormData = AuthFormData();

  void _handleImagePick(File image) {
    _authFormData.image = image;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSignUp) {
      return _showError('Imagem não selecionada');
    }

    widget.onSubmit(_authFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSignUp)
                UserImagePicker(
                  onImagePick: _handleImagePick,
                ),
              if (_authFormData.isSignUp)
                TextFormField(
                  key: ValueKey('name'),
                  initialValue: _authFormData.name,
                  onChanged: (name) => _authFormData.name = name,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (_name) {
                    String name = _name ?? '';
                    if (name.trim().length < 3) {
                      return 'Nome deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: ValueKey('email'),
                initialValue: _authFormData.email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (email) => _authFormData.email = email,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (_email) {
                  String email = _email ?? '';
                  if (!email.contains('@')) {
                    return 'E-mail informado não é válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: ValueKey('password'),
                initialValue: _authFormData.password,
                onChanged: (password) => _authFormData.password = password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (_password) {
                  String password = _password ?? '';
                  if (password.contains(' ')) {
                    return 'Senha não pode conter espaços em branco';
                  }
                  if (password.length < 6) {
                    return 'Senha deve conter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_authFormData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                child: Text(_authFormData.isLogin
                    ? 'Criar uma nova conta?'
                    : 'Já possui conta?'),
                onPressed: () {
                  setState(() {
                    _authFormData.toggleAuthMode();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
