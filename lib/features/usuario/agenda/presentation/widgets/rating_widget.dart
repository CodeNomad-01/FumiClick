import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final int? currentRating;
  final bool interactive;
  final Function(int)? onRatingChanged;
  final double size;

  const RatingWidget({
    super.key,
    this.currentRating,
    this.interactive = false,
    this.onRatingChanged,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = currentRating != null && starIndex <= currentRating!;

        return GestureDetector(
          onTap:
              interactive
                  ? () {
                    onRatingChanged?.call(starIndex);
                  }
                  : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              color: isFilled ? Colors.amber : colorScheme.onSurfaceVariant,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String title;
  final String appointmentTitle;
  final int? initialRating;
  final String? initialComment;

  const RatingDialog({
    super.key,
    required this.title,
    required this.appointmentTitle,
    this.initialRating,
    this.initialComment,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int selectedRating;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    selectedRating = widget.initialRating ?? 0;
    commentController = TextEditingController(
      text: widget.initialComment ?? '',
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Servicio: ${widget.appointmentTitle}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: RatingWidget(
                currentRating: selectedRating,
                interactive: true,
                onRatingChanged: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                },
                size: 32.0,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _getRatingText(selectedRating),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: 'Comentario (opcional)',
                hintText: '¿Cómo fue tu experiencia con el servicio?',
                border: const OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed:
              selectedRating > 0
                  ? () => Navigator.of(context).pop({
                    'rating': selectedRating,
                    'comment': commentController.text.trim(),
                  })
                  : null,
          child: const Text('Enviar Reseña'),
        ),
      ],
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Muy malo';
      case 2:
        return 'Malo';
      case 3:
        return 'Regular';
      case 4:
        return 'Bueno';
      case 5:
        return 'Excelente';
      default:
        return 'Toca una estrella para calificar';
    }
  }
}
