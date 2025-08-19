String? notNullOrEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

String? emailValidator(String value) {
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address.';
  }
  return null;
}

String? passwordValidator(String value) {
  final passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  );
  if (!passwordRegex.hasMatch(value)) {
    return 'Password must be at least 8 characters long and include both letters and numbers.';
  }
  return null;
}

String? confirmPasswordValidator(String password, String confirmPassword) {
  if (password != confirmPassword) {
    return "Passwords doesn't match";
  }
  return null;
}
