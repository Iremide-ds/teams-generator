import 'package:flutter/material.dart';
import 'package:teams_gen/src/shared/extensions/buildcontext.dart';
import 'package:teams_gen/src/shared/extensions/color.dart';

/// A reusable scaffold that handles:
/// - Loading state
/// - Error / empty UI
/// - Pull-to-refresh
/// - Consistent padding and theming
///
/// Usage:
/// ```dart
/// AppScaffold(
///   title: "Dashboard",
///   isLoading: controller.isLoading,
///   onRefresh: controller.loadData,
///   body: DashboardContent(),
/// )
/// ```
class AppScaffold extends StatelessWidget {
  final String? title;
  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final Widget? body;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    this.title,
    this.body,
    this.isLoading = false,
    this.hasError = false,
    this.isEmpty = false,
    this.floatingActionButton,
    this.onRefresh,
    this.onRetry,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    // Handle different UI states
    if (isLoading) {
      content = Center(
        key: ValueKey('AppScaffold(${key?.hashCode})-center_spinner'),
        child: CircularProgressIndicator(),
      );
    } else if (hasError) {
      content = _ErrorView(
        key: ValueKey('AppScaffold(${key?.hashCode})-_Error_Widget'),
        onRetry: onRetry,
      );
    } else if (isEmpty) {
      content = _EmptyView(
        key: ValueKey('AppScaffold(${key?.hashCode})-_Empty_View'),
      );
    } else {
      content = body ?? const SizedBox.shrink();
    }

    // Optional refresh wrapper
    if (onRefresh != null && !isLoading && !hasError) {
      content = RefreshIndicator(
        key: ValueKey('AppScaffold(${key?.hashCode})-Refresh_Indicator'),
        onRefresh: onRefresh!,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: content,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(
                title!,
                style: context.theme.textTheme.headlineMedium,
              ),
              centerTitle: true,
              actions: actions,
              bottom: bottom,
            )
          : null,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: content,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Shown when there's an error
class _ErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  const _ErrorView({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.theme.textTheme.bodyMedium?.color?.wOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shown when there's no data
class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No Data Available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later or add something new!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.theme.textTheme.bodyMedium?.color?.wOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
