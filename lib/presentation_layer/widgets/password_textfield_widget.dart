import 'package:flutter/material.dart';
import 'package:maps_flutter/presentation_layer/widgets/textformfield_widget.dart';

typedef StrengthCallback = void Function(double strength);
typedef PasswordCallback = void Function(String password);

class BuildPasswordFormFieldWithChecker extends StatefulWidget {
  final StrengthCallback onStrengthChanged;
  final PasswordCallback getPassword;
  const BuildPasswordFormFieldWithChecker({
    super.key,
    required this.onStrengthChanged,
    required this.getPassword,
  });

  @override
  State<BuildPasswordFormFieldWithChecker> createState() =>
      _BuildPasswordFormFieldWithCheckerState();
}

class _BuildPasswordFormFieldWithCheckerState
    extends State<BuildPasswordFormFieldWithChecker> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;
//regular expression for number that used in password
  final RegExp _numReg = RegExp(r'.*[0-9].*');
  //regular expression for letters that used in password
  final RegExp _letterReg = RegExp(r'.*[A-Za-z].*');
  String? _displayText;
  Color? _displayTextColor;
  double _strength = 0;

  void _checkPassword(String value) {
    _passwordController.text = value.trim();
    widget.getPassword(value.trim());
    if (_passwordController.text.isEmpty) {
      setState(() {
        _strength = 0;
      });
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _strength = 0.25;
        _displayText = 'Weak Password';
        _displayTextColor = Colors.red;
      });
    } else if (_passwordController.text.length < 12) {
      setState(() {
        _strength = 0.5;
        _displayText = 'Medium Password';
        _displayTextColor = Colors.orange;
      });
    } else {
      setState(() {
        _strength = 1;
        _displayText = 'Strong Password';
        _displayTextColor = Colors.green;
      });
    }
    widget.onStrengthChanged(_strength);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextFormField(
          textEditingController: _passwordController,
          textInputType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty) {
              return 'This field is required';
            } else if (!_numReg.hasMatch(value) &&
                !_letterReg.hasMatch(value)) {
              return 'Password must contains numbers and letters';
            } else if (_strength < 0.5) {
              return 'Password must be medium or strong !';
            }
            return null;
          },
          label: const Text(
            'Please Enter Your Password',
            style: TextStyle(fontSize: 15),
          ),
          prefixIcon: Icons.lock,
          suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
          obscureText: _obscureText,

          suffixPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          onChanged: (value) {
            _checkPassword(value!);
            //to make the keyboard or mouse indicator starts at the last letter written
            _passwordController.selection = TextSelection.collapsed(
                offset: _passwordController.text.length);
          },
          //to make the values that was written in password field is written also in confirm password field
          // onChanged: (value) {
          //   _confirmPasswordController.text = value!;
          // },
        ),
        const SizedBox(
          height: 20.0,
        ),
        LinearProgressIndicator(
          value: _strength,
          color: _strength <= 0.25
              ? Colors.red
              : _strength <= 0.5
                  ? Colors.orange
                  : Colors.green,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          _strength == 0 ? '' : _displayText!,
          style: TextStyle(color: _displayTextColor),
        ),
        const SizedBox(
          height: 20.0,
        ),
        buildTextFormField(
          textEditingController: _confirmPasswordController,
          textInputType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty) {
              return 'This field is required';
            }
            if (value != _passwordController.text) {
              return 'Password doesn\'t match ';
            }
            return null;
          },
          label: const Text(
            'Please Confirm Your Password',
            style: TextStyle(fontSize: 15),
          ),
          prefixIcon: Icons.lock,
          obscureText: _obscureText,
          onChanged: (value) {
            _confirmPasswordController.selection = TextSelection.collapsed(
                offset: _confirmPasswordController.text.length);
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
