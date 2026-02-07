import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
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
              SnackBar(content: Text('Welcome, ${next.value!.fullName}'), backgroundColor: Colors.green),
            );
            Navigator.pushReplacementNamed(context, '/home');
         }
      }
    });

    final isLoading = authState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
      ),
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
                  // Minimal Header
                  Icon(
                    Icons.person_add_outlined, 
                    size: 60.sp, 
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Join Community',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 40.h),

                  // Form Section
                   Text(
                    'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 32.h),

                   // Name Input
                  TextFormField(
                    controller: fullNameController,
                    style: GoogleFonts.poppins(color: colorScheme.onBackground),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                      // Theme handles borders
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 20.h),
                  
                  // Email Input
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(color: colorScheme.onBackground),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
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

                  // Register Button
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              ref.read(authProvider.notifier).register(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    fullNameController.text.trim(),
                                  );
                            }
                          },
                    // Theme handles style
                     child: isLoading
                        ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                        : Text(
                            'Create Account',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                  ),
                   SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: GoogleFonts.poppins(color: colorScheme.onBackground.withOpacity(0.6))),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Sign In",
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
