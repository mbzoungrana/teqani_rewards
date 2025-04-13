import 'package:flutter/material.dart';
import 'dart:async';
import '../models/challenge.dart';

class ChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback? onComplete;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onComplete,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  Duration? _bonusRemainingTime;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemainingTime() {
    setState(() {
      _remainingTime = widget.challenge.getRemainingTime();
      _bonusRemainingTime = widget.challenge.getBonusRemainingTime();
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.challenge.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.challenge.points} pts',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.challenge.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Time remaining: ${_formatDuration(_remainingTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (_bonusRemainingTime != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.stars, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    'Bonus ends in: ${_formatDuration(_bonusRemainingTime!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.amber,
                        ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.challenge.isCompleted
                    ? null
                    : () => widget.onComplete?.call(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  widget.challenge.isCompleted ? 'Completed' : 'Complete Challenge',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 