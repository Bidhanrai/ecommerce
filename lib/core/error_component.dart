import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class ErrorComponent extends StatelessWidget {
  final String? exception;
  final VoidCallback? retry;

  const ErrorComponent({
    super.key,
    required this.exception,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
              maxLines: 5,
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
          ],
        ),
      ),
    );
  }
}
