import 'package:flutter/material.dart';
import 'package:fumi_click/features/auth/presentation/widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1200;
    final isLandscape = screenSize.width > screenSize.height;

    final horizontalPadding = isDesktop ? 80.0 : (isTablet ? 40.0 : 24.0);
    final maxWidth = isDesktop ? 420.0 : (isTablet ? 500.0 : double.infinity);
    final logoSize = isTablet ? 100.0 : 80.0;
    final topSpacing = isLandscape ? 40.0 : (isTablet ? 80.0 : 60.0);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Container(
                width: maxWidth,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: topSpacing * 0.5),

                    Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.coronavirus_sharp,
                        size: logoSize * 0.5,
                        color: colorScheme.onPrimary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Únete a Fumi Click",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "Únete y protege tus espacios",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Sign up form
                    Card(
                      color: colorScheme.surfaceContainerHigh,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                        child: const SignUpForm(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          children: [
                            const TextSpan(text: "¿Ya tienes cuenta? "),
                            TextSpan(
                              text: "Inicia sesión",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
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
