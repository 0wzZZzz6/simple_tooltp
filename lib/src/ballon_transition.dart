part of tooltip;

class _BalloonTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final TooltipDirection tooltipDirection;
  final bool hide;
  final Function(AnimationStatus) animationEnd;

  _BalloonTransition({
    Key key,
    @required this.child,
    @required this.duration,
    @required this.tooltipDirection,
    this.hide = false,
    this.animationEnd,
  }) : super(key: key);

  @override
  _BalloonTransitionState createState() => _BalloonTransitionState();
}

class _BalloonTransitionState extends State<_BalloonTransition>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: _animationController,
    );

    if (!widget.hide) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _animationController.addStatusListener((status) {
      if ((status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) &&
          widget.animationEnd != null) {
        widget.animationEnd(status);
      }
    });
  }

  @override
  void didUpdateWidget(_BalloonTransition oldWidget) {
    if (widget.hide) {
      _animationController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
