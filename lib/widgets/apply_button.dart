import 'package:flutter/material.dart';



class ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApplyButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2 * 16.0,
        vertical: 5 * 16.0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.yellow,
          onPrimary: Colors.black,
          alignment: Alignment.center,
          // shape: const StadiumBorder(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          minimumSize: const Size(double.infinity, 80.0),
        ),
        child: const Text("Apply for a job"),
      ),
    );
  }
}
