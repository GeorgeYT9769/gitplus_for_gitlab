import 'package:flutter/material.dart';

class DateTimeField extends StatefulWidget {
  const DateTimeField({
    Key? key,
    required this.labelText,
    this.controller,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  final String labelText;
  final TextEditingController? controller;
  final String? initialValue;
  final void Function(String)? onChanged;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_controller.text) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formatted = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        _controller.text = formatted;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: widget.labelText,
          errorStyle: const TextStyle(color: Colors.red),
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onTap: () => _selectDate(context),
        validator: (val) => null,
      ),
    );
  }
}