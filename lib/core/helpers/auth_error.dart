String getLoginErrorMessage(String code) {
  switch (code) {
    case 'user-not-found': return 'No account found with this email.';
    case 'wrong-password': return 'Incorrect password. Try again.';
    case 'invalid-email': return 'Please enter a valid email address.';
    case 'too-many-requests': return 'Too many attempts. Please try again later.';
    default: return 'Login failed. Please retry again.';
  }
}
String getSignUpErrorMessage(String code) {
  switch (code) {
    case 'weak-password': return 'Password is too weak. Use at least 6 characters.';
    case 'email-already-in-use': return 'An account already exists with this email.';
    default: return 'SignUp  failed. Please retry again.';
  }
}