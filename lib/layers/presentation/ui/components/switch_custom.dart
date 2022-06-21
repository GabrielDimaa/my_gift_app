import 'package:flutter/material.dart';

class SwitchCustom extends StatefulWidget {
  final bool active;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final Color inactiveColor;
  final void Function(bool value) onChanged;

  const SwitchCustom({
    Key? key,
    required this.active,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
  }) : super(key: key);

  @override
  State<SwitchCustom> createState() => _SwitchCustomState();
}

class _SwitchCustomState extends State<SwitchCustom> {
  late bool _active;

  @override
  void initState() {
    _active = widget.active;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() => _active = !_active);
        Future.delayed(const Duration(milliseconds: 400), () => widget.onChanged.call(_active));
      },
      child: SizedBox(
        height: 28,
        width: 66,
        child: Stack(
          alignment: _active ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: _active ? widget.activeColor : widget.inactiveColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Align(
                  alignment: _active ? Alignment.centerLeft : Alignment.centerRight,
                  child: Icon(_active ? widget.activeIcon : widget.inactiveIcon, size: 20, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedAlign(
                alignment: _active ? Alignment.centerRight : Alignment.centerLeft,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
