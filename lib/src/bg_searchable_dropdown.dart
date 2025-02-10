import 'package:flutter/material.dart';

/// A customizable searchable dropdown widget for Flutter.
class BGSearchableDropDown extends StatefulWidget {
  /// The list of items to display in the dropdown.
  final List<String> items;

  /// The hint text to display when no item is selected.
  final String hint;

  /// The text to display for the clear option.
  final String clearOptionText;

  /// A callback function that is called when the selected item changes.
  final Function(String?) onChanged;

  /// The border color of the dropdown.
  final Color borderColor;

  /// The border radius of the dropdown.
  final double borderRadius;

  /// The maximum height of the dropdown list.
  final double dropdownHeight;

  /// The icon to display in the dropdown.
  final Icon dropdownIcon;

  /// Whether to show the clear button.
  final bool showClearButton;

  /// The text style for the items in the dropdown.
  final TextStyle textStyle;

  /// The label text for the search field.
  final String? searchLabelText;

  /// Creates a new BGSearchableDropDown.
  const BGSearchableDropDown({
    super.key,
    required this.items,
    required this.hint,
    required this.clearOptionText,
    required this.onChanged,
    this.borderColor = Colors.grey,
    this.borderRadius = 8.0,
    this.dropdownHeight = 300.0,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.showClearButton = true,
    this.textStyle = const TextStyle(fontSize: 16),
    this.searchLabelText,
  });

  @override
  State<BGSearchableDropDown> createState() => _BGSearchableDropDownState();
}

class _BGSearchableDropDownState extends State<BGSearchableDropDown> {
  String? selectedItem;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 5), // Adjusted offset
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: _filteredItems.isEmpty // Handle empty list height
                  ? (widget.showClearButton ? 100 : 50) // Adjust as needed
                  : widget.dropdownHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: widget.searchLabelText ?? "Search...",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        setState(() {
                          _filteredItems = widget.items
                              .where((item) => item
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        });
                        _overlayEntry?.markNeedsBuild();
                      },
                    ),
                  ),
                  if (widget.showClearButton)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedItem = null;
                            _searchController.clear();
                            _filteredItems = widget.items;
                          });
                          widget.onChanged(null);
                          _overlayEntry?.markNeedsBuild();
                        },
                        child: Text(
                          widget.clearOptionText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: _filteredItems.isEmpty // Handle empty list
                        ? Center(
                            child:
                                Text("No items found", style: widget.textStyle))
                        : ListView.builder(
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_filteredItems[index],
                                    style: widget.textStyle),
                                onTap: () {
                                  setState(() {
                                    selectedItem = _filteredItems[index];
                                  });
                                  widget.onChanged(
                                      selectedItem); // No need for ! as selectedItem is handled
                                  _hideDropdown();
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedItem ?? widget.hint, style: widget.textStyle),
              widget.dropdownIcon,
            ],
          ),
        ),
      ),
    );
  }
}
