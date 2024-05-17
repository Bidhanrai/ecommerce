import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class ErrorPage extends StatelessWidget {
  final String? exception;
  final VoidCallback? retry;

  const ErrorPage({
    super.key,
    required this.exception,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 50),
              Text(
                exception?? "Something went wrong",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                "Please try again later. Or contact your service provider.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 24),
              Button.primary(
                label: "Try Again",
                onTap: () {
                  if(retry != null) {
                    retry!();
                  }
                },
              ),
              const SizedBox(height: 12),
              Navigator.canPop(context)
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Go Back"),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
