import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> selected;
  final List<String> availableSpecialties;
  final Color primaryColor;

  const MultiSelectDialog({
    super.key,
    required this.selected,
    required this.availableSpecialties,
    required this.primaryColor,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelected;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final filteredSpecialties = _searchQuery.isEmpty
        ? widget.availableSpecialties
        : widget.availableSpecialties
            .where((spec) => spec.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return AlertDialog(
      title: const Text('Select Specialties'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search specialties...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 10),
            
            // Select All button
            TextButton(
              onPressed: _toggleSelectAll,
              child: Text(
                _tempSelected.length == widget.availableSpecialties.length
                    ? 'Deselect All'
                    : 'Select All',
                style: TextStyle(
                  color: widget.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Specialties list
            Expanded(
              child: filteredSpecialties.isEmpty
                  ? const Center(child: Text('No specialties found'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredSpecialties.length,
                      itemBuilder: (context, index) {
                        final specialty = filteredSpecialties[index];
                        return CheckboxListTile(
                          title: Text(specialty),
                          value: _tempSelected.contains(specialty),
                          activeColor: widget.primaryColor,
                          checkColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) => _toggleSpecialty(specialty, value),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempSelected),
          child: Text('OK', style: TextStyle(
            color: widget.primaryColor,
            fontWeight: FontWeight.bold,
          )),
        ),
      ],
    );
  }
 void _toggleSpecialty(String specialty, bool? value) {
    setState(() {
      if (value == true) {
        _tempSelected.add(specialty);
      } else {
        _tempSelected.remove(specialty);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_tempSelected.length == widget.availableSpecialties.length) {
        _tempSelected.clear();
      } else {
        _tempSelected = List.from(widget.availableSpecialties);
      }
    });
  }
}