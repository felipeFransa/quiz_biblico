import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AnswerButton extends StatefulWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback? onTap;

  const AnswerButton({
    super.key,
    required this.text,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    this.onTap,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (!widget.hasAnswered) return AppTheme.cardBg;
    if (widget.isCorrect) return AppTheme.correct.withValues(alpha: 0.9);
    if (widget.isSelected && !widget.isCorrect) {
      return AppTheme.wrong.withValues(alpha: 0.9);
    }
    return AppTheme.cardBg.withValues(alpha: 0.4);
  }

  Color get _borderColor {
    if (!widget.hasAnswered) {
      return const Color(0xFF4A3A7A);
    }
    if (widget.isCorrect) return AppTheme.correct;
    if (widget.isSelected && !widget.isCorrect) return AppTheme.wrong;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: widget.hasAnswered ? null : (_) => _controller.forward(),
        onTapUp: widget.hasAnswered
            ? null
            : (_) {
                _controller.reverse();
                widget.onTap?.call();
              },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 2),
          ),
          child: Row(
            children: [
              _buildLabel(),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: widget.hasAnswered && !widget.isCorrect &&
                                !widget.isSelected
                            ? Colors.white38
                            : Colors.white,
                        fontWeight: widget.isSelected || widget.isCorrect
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                ),
              ),
              if (widget.hasAnswered && widget.isCorrect)
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 22),
              if (widget.hasAnswered && widget.isSelected && !widget.isCorrect)
                const Icon(Icons.cancel_rounded,
                    color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    const labels = ['A', 'B', 'C', 'D'];
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.hasAnswered
            ? Colors.white.withValues(alpha: 0.15)
            : AppTheme.accent.withValues(alpha: 0.15),
        border: Border.all(
          color: widget.hasAnswered
              ? Colors.white30
              : AppTheme.accent.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        labels[widget.index],
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
          color: widget.hasAnswered ? Colors.white60 : AppTheme.accent,
        ),
      ),
    );
  }
}
