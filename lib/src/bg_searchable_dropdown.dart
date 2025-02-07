import 'package:flutter/material.dart';

class BGSearchableDropDown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final String clearOptionText;
  final Function(String?) onChanged;
  final Color borderColor;
  final double borderRadius;
  final double dropdownHeight;
  final Icon dropdownIcon;
  final bool showClearButton;
  final TextStyle textStyle;
  final String? searchLabelText;

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
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: widget.dropdownHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                color: Colors.white,
                boxShadow: [
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
                        child: Text(
                          widget.clearOptionText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedItem = null;
                            _searchController.clear();
                            _filteredItems = widget.items;
                          });
                          widget.onChanged(null);
                          _overlayEntry?.markNeedsBuild();
                        },
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredItems[index],
                              style: widget.textStyle),
                          onTap: () {
                            setState(() {
                              selectedItem = _filteredItems[index];
                            });
                            widget.onChanged(selectedItem!);
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
