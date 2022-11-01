import 'package:flutter/material.dart';
import '../utils/validators.dart';

class PasswordTextFieldWithValidation extends StatefulWidget {
  const PasswordTextFieldWithValidation({super.key});

  @override
  State<PasswordTextFieldWithValidation> createState() => PasswordTextFieldWithValidationState();
}

class PasswordTextFieldWithValidationState extends State<PasswordTextFieldWithValidation> {
  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _hasUppercaseCharacters = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordhavenumber = false;
  bool _hasSpecialCharacter = false;

  String getPassword() => controller.text;
  bool validate() =>
      _hasUppercaseCharacters && _isPasswordEightCharacters && _hasPasswordhavenumber && _hasSpecialCharacter;
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            validator: (value) {
              _hasPasswordhavenumber = Validators.numericsPresent(value ?? '');
              _isPasswordEightCharacters = Validators.minLengthCorrect(value ?? '', 8);
              _hasUppercaseCharacters = Validators.uppercasePresent(value ?? '');
              _hasSpecialCharacter = Validators.specialCharactersPresent(value ?? '');
              setState(() {});
              if (validate()) {
                return null;
              }

              return 'Yanlis';
            },
            obscureText: !_isVisible,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Color.fromARGB(255, 146, 146, 146),
                        ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 148, 146, 146))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                hintText: 'Password',
                contentPadding: const EdgeInsets.all(20.0)),
            controller: controller,
            onChanged: (value) => formKey.currentState?.validate(),
          ),
        ),
        const SizedBox(height: 20),
        _checkRow('Contains at least 8 characters', _isPasswordEightCharacters),
        const SizedBox(
          height: 10,
        ),
        _checkRow('Contains 1 uppercase character', _hasUppercaseCharacters),
        const SizedBox(
          height: 10,
        ),
        _checkRow('Contains 1 number', _hasPasswordhavenumber),
        const SizedBox(
          height: 10,
        ),
        _checkRow('Contains 1 special character', _hasSpecialCharacter),
      ],
    );
  }

  Row _checkRow(String data, bool check) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: check ? Colors.green : Colors.transparent,
            border: check ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(data),
      ],
    );
  }
}
