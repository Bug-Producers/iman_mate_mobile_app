import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      } else if (next.hasValue && next.value != null && !next.isLoading) {
         if (previous?.value == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome Back, ${next.value!.fullName}'), backgroundColor: Colors.green),
            );
            Navigator.pushReplacementNamed(context, '/home');
         }
      }
    });

    final isLoading = authState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // Minimal Logo Section
                  Icon(
                    Icons.mosque_outlined, 
                    size: 80.sp, 
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Iman Mate',
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Your Faithful Companion',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: colorScheme.onBackground.withOpacity(0.7),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 48.h),

                  // Form Section
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   const SizedBox(height: 8),
                   Text(
                    'Sign in to your account',
                    style: GoogleFonts.poppins(
                      color: colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                   ),
                  SizedBox(height: 32.h),

                  // Email Input
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(color: colorScheme.onBackground),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                      // Theme handles borders/colors
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 20.h),

                  // Password Input
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: GoogleFonts.poppins(color: colorScheme.onBackground),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 32.h),

                  // Login Button
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              ref.read(authProvider.notifier).login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            }
                          },
                    // Theme handles button style
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                        : Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  Row(
                    children: [
                      Expanded(child: Divider(color: colorScheme.onBackground.withOpacity(0.2))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text("OR", style: GoogleFonts.poppins(color: colorScheme.onBackground.withOpacity(0.4), fontWeight: FontWeight.w500)),
                      ),
                      Expanded(child: Divider(color: colorScheme.onBackground.withOpacity(0.2))),
                    ],
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Google Button
                  OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            ref.read(authProvider.notifier).googleSignIn();
                          },
                    // Theme handles styling, but we need custom layout for icon
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                    ),
                    icon: Image.network(
                      'https://www.google.com/favicon.ico',
                      height: 24.h,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.g_mobiledata, size: 24, color: colorScheme.onBackground),
                    ),
                    label: Text(
                      'Continue with Google',
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h), // Spacing before footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: GoogleFonts.poppins(color: colorScheme.onBackground.withOpacity(0.6))),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
