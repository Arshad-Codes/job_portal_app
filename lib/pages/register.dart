import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_portal_app/pages/job_crud.dart';
import 'package:job_portal_app/pages/login_page.dart';
import 'package:job_portal_app/resources/auth.dart';
import 'package:job_portal_app/resources/utils.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<Register> {
  final TextEditingController _companynameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyDescController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companynameController.dispose();
    _companyDescController.dispose();
  }

  void signUp() async {
    // set loading to true
    if (_companyDescController.text.isNotEmpty &&
        _companynameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _image != null) {
      if (_confirmPasswordController.text == _passwordController.text) {
        setState(() {
          _isLoading = true;
        });
        try {
          String response = await Auth().signUpUser(
              email: _emailController.text,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
              companyName: _companynameController.text,
              companyDesc: _companyDescController.text,
              file: _image!);
          if (response != "success") {
            snackBarMessage(context, response);
          } else {
            setState(() {
              _isLoading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobCrudPage()),
            );
          }
        } catch (err) {
          setState(() {
            _isLoading = false;
          });
          snackBarMessage(context, err.toString());
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        snackBarMessage(
            context, "Your password and confirm password fiels doesn't match");
      }
    } else if (_image == null) {
      snackBarMessage(context, "Please insert an company logo");
    } else {
      snackBarMessage(context, "Please fill all the fields");
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeader("Register"),
              const SizedBox(height: 24),
              buildImagePicker(),
              const SizedBox(height: 24),
              buildTextField("Company name", _companynameController),
              const SizedBox(height: 24),
              buildTextField("Email", _emailController),
              const SizedBox(height: 24),
              buildTextField("Password", _passwordController, isPassword: true),
              const SizedBox(height: 12),
              buildTextField("Confirm Password", _confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 24),
              buildTextField("Company Description", _companyDescController),
              const SizedBox(height: 24),
              buildSignUpButton(),
              const SizedBox(height: 12),
              buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(String title) {
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          left: 30,
          width: 80,
          height: 200,
          child: FadeInUp(
            duration: Duration(seconds: 1),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/light-1.png'),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 140,
          width: 80,
          height: 150,
          child: FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/light-2.png'),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 40,
          top: 40,
          width: 80,
          height: 150,
          child: FadeInUp(
            duration: Duration(milliseconds: 1300),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/clock.png'),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 30,
          child: FadeInUp(
            duration: Duration(milliseconds: 1600),
            child: Container(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImagePicker() {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(
                radius: 64,
                backgroundImage: MemoryImage(_image!),
                backgroundColor: Color.fromARGB(255, 189, 90, 243),
              )
            : const CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                  'https://i.stack.imgur.com/l60Hf.png',
                ),
                backgroundColor: Color.fromARGB(255, 189, 90, 243),
              ),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: FadeInUp(
        duration: Duration(milliseconds: 1800),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your $hintText',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(143, 148, 251, 1),
              ),
            ),
          ),
          keyboardType: TextInputType.text,
          controller: controller,
          obscureText: isPassword,
        ),
      ),
    );
  }

  Widget buildSignUpButton() {
    return InkWell(
      onTap: signUp,
      child: FadeInUp(
        duration: Duration(milliseconds: 1900),
        child: Container(
          width: 200,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(91, 97, 209, 1),
                Color.fromRGBO(143, 148, 251, 1),
              ],
            ),
          ),
          child: !_isLoading
              ? const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                )
              : const CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  Widget buildLoginLink() {
    return FadeInUp(
      duration: Duration(milliseconds: 2000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text('Already have an account?'),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                ' Login.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(143, 148, 251, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
