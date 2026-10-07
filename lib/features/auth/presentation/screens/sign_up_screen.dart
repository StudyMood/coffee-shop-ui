import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/core/widgets/custom_text_field.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // 1. Strict Form Validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final referralCode = _referralController.text.trim();

    setState(() => _isLoading = true);

    // Show visible progress feedback message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Registering account in Firebase... Please wait ☕',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryCoffee,
        duration: const Duration(seconds: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    try {
      final auth = ref.read(authServiceProvider);
      await auth.signUpWithEmailAndPassword(
        name: name,
        email: email,
        phone: '+91 $phone',
        password: password,
        referralCode: referralCode,
      );

      // User requirement: after registering, user must login first to reach home page
      await auth.signOut();

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show clear confirmation dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Account Created!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $name! ☕\n\nYour account has been registered and securely saved in Firebase.',
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryCoffee.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_open_rounded, color: AppColors.primaryCoffee, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please sign in with your email ($email) and password to access the app.',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCoffee,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              ),
              child: const Text('Proceed to Sign In'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      // Navigate to Sign In screen with prefilled email
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => SignInScreen(
            initialEmail: email,
            initialMessage: 'Registration successful! Enter your password to sign in.',
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      String errorMessage = 'Sign up failed. Please try again.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already registered. Please sign in.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is invalid.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak. Choose at least 6 characters.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/Password sign-in is disabled in Firebase Console.';
            break;
          default:
            errorMessage = e.message ?? e.code;
        }
      } else {
        final errStr = e.toString();
        if (errStr.contains('permission-denied')) {
          errorMessage = 'Firestore permission denied. Please check Firestore security rules.';
        } else if (errStr.contains('403') || errStr.contains('Cloud Firestore API')) {
          errorMessage = 'Cloud Firestore is not enabled yet in Firebase project.';
        } else {
          errorMessage = errStr;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(errorMessage)),
            ],
          ),
          backgroundColor: AppColors.accentRed,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join the Coffee Circle ☕',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign up to earn loyalty points on every cup and save your favorites.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Full Name (Required)
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name *',
                hintText: 'e.g. Abhishek Kumar',
                prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryCoffee),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Full Name is required';
                  }
                  if (val.trim().length < 2) {
                    return 'Please enter a valid name (at least 2 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Email (Required)
              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address *',
                hintText: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.primaryCoffee),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Phone Number (Required, Exactly 10 Digits)
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number (10 Digits) *',
                hintText: '9876543210',
                prefixText: '+91 ',
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primaryCoffee),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                  if (clean.length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(clean)) {
                    return 'Enter a valid 10-digit mobile number starting with 6-9';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Password (Required, Min 6 Chars)
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password *',
                hintText: 'Minimum 6 characters',
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryCoffee),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textMutedLight,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password is required';
                  }
                  if (val.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Confirm Password (Required, Matching)
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password *',
                hintText: 'Re-enter your password',
                obscureText: _obscureConfirmPassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryCoffee),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textMutedLight,
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (val != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 6. Referral Code (Optional)
              CustomTextField(
                controller: _referralController,
                labelText: 'Referral Code (Optional)',
                hintText: 'e.g. BREWAARAV (Get +50 bonus pts)',
                prefixIcon: const Icon(Icons.card_giftcard_rounded, color: AppColors.primaryCoffee),
              ),
              const SizedBox(height: 28),

              // Submit Button
              CustomButton(
                text: 'Create Account',
                isLoading: _isLoading,
                onPressed: _signUp,
              ),
              const SizedBox(height: 20),

              // Already have an account? Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryCoffee,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Center(
                child: Text(
                  'By signing up, you agree to Caffè Royale Terms & Privacy.',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
