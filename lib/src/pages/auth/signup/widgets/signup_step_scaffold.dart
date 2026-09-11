import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:lexxi/src/global/design_system/typography.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_progress_header.dart';

class SignupStepScaffold extends StatefulWidget {
  final String? imageAsset;
  final String? title;
  final String? subtitle;
  final String? description;
  final Widget content;
  final Widget? checkContent;
  final String continueLabel;
  final bool checkValue;
  final ValueChanged<bool?>? onCheckChanged;
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
    this.checkContent,
    this.checkValue = false,
    this.onCheckChanged,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<SignupStepScaffold> createState() => _SignupStepScaffoldState();
}

class _SignupStepScaffoldState extends State<SignupStepScaffold> {
  @override
  void initState() {
    super.initState();
    _showErrorToast(widget.errorMessage);
  }

  @override
  void didUpdateWidget(covariant SignupStepScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage != oldWidget.errorMessage) {
      _showErrorToast(widget.errorMessage);
    }
  }

  void _showErrorToast(String? message) {
    if (message == null || message.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      MotionToast.error(
        toastDuration: const Duration(seconds: 3),
        description: Text(message),
      ).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            SignupProgressHeader(
              currentStep: widget.currentStep,
              totalSteps: widget.totalSteps,
              onBack: widget.onBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.title != null) ...[
                      Text(
                        widget.title!,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                    if (widget.imageAsset != null) ...[
                      const SizedBox(height: 10),
                      Image.asset(
                        widget.imageAsset!,
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(height: 180),
                      ),
                    ],
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ],
                    widget.content,
                    if (widget.description != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        widget.description!,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMediumItalic.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                    if (widget.checkContent != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: widget.checkValue,
                            onChanged: widget.onCheckChanged,
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                          ),
                          Expanded(child: widget.checkContent!),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (widget.isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.white),
              )
            else
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: widget.continueLabel,
                  onPressed: widget.onContinue ?? () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
