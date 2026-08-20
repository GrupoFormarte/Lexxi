import 'package:flutter/material.dart';
import 'package:lexxi/src/global/design_system/typography.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_progress_header.dart';

class SignupStepScaffold extends StatelessWidget {
  final String? imageAsset;
  final String? title;
  final String? subtitle;
  final String? description;
  final Widget content;
  final String continueLabel;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final bool isLoading;
  final String? errorMessage;
  final int currentStep;
  final int totalSteps;

  const SignupStepScaffold({
    super.key,
    this.imageAsset,
    this.title,
    this.subtitle,
    this.description,
    required this.content,
    required this.currentStep,
    required this.totalSteps,
    this.continueLabel = 'Continuar',
    this.onContinue,
    this.onBack,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            SignupProgressHeader(
              currentStep: currentStep,
              totalSteps: totalSteps,
              onBack: onBack,
            ),

            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                    if (imageAsset != null) ...[
                      const SizedBox(height: 10),
                      Image.asset(
                        imageAsset!,
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(height: 180),
                      ),
                    ],
                    if (subtitle != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ],

                    content,
                    if (description != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        description!,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMediumItalic.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                    if (errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.redAccent[100],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.white),
              )
            else
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: continueLabel,
                  onPressed: onContinue ?? () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
