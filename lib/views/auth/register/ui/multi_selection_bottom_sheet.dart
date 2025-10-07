import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/service_model.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';

class MultiSelectBottomSheet extends StatefulWidget {
  final String title;
  final List<ServiceModel> items;
  final List<ServiceModel> selectedItems;
  final Function(List<ServiceModel>) onSelectionChanged;
  final String itemType;

  const MultiSelectBottomSheet({super.key, required this.title, required this.items, required this.selectedItems, required this.onSelectionChanged, required this.itemType});

  @override
  State<MultiSelectBottomSheet> createState() => _MultiSelectBottomSheetState();
}

class _MultiSelectBottomSheetState extends State<MultiSelectBottomSheet> {
  late List<ServiceModel> _tempSelected;
  final TextEditingController _searchController = TextEditingController();
  List<ServiceModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedItems);
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) => item.name.toLowerCase().contains(query) || item.description.toLowerCase().contains(query)).toList();
      }
    });
  }

  void _toggleSelection(ServiceModel item) {
    setState(() {
      if (_tempSelected.contains(item)) {
        _tempSelected.remove(item);
      } else {
        _tempSelected.add(item);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _tempSelected = List.from(widget.items);
    });
  }

  void _clearAll() {
    setState(() {
      _tempSelected.clear();
    });
  }

  void _confirmSelection() {
    widget.onSelectionChanged(_tempSelected);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(child: Column(children: [_buildHeaderSection(), _buildSearchSection(), _buildSelectionActions(), _buildServicesList(), _buildBottomActions()])),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, color: AppTheme.textSecondary, size: 24),
            style: IconButton.styleFrom(backgroundColor: AppTheme.backgroundLight, padding: const EdgeInsets.all(8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Select medical services you offer',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search medical services...',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterItems();
                    },
                    icon: Icon(Icons.close_rounded, color: AppTheme.textLight, size: 18),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
        ),
      ),
    );
  }

  Widget _buildSelectionActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _selectAll,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: AppTheme.borderColor),
              ),
              child: Text(
                'Select All',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: _clearAll,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Text(
                'Clear All',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return Expanded(
      child: _filteredItems.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = _tempSelected.contains(item);
                return _buildServiceItem(item, isSelected);
              },
            ),
    );
  }

  Widget _buildServiceItem(ServiceModel item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryBlue.withOpacity(0.05) : AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppTheme.primaryBlue : AppTheme.borderColor, width: isSelected ? 1.5 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleSelection(item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: isSelected ? AppTheme.primaryBlue : AppTheme.backgroundLight, borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.icon, color: isSelected ? Colors.white : AppTheme.primaryBlue, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppTheme.textSecondary, letterSpacing: .5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? AppTheme.primaryBlue : AppTheme.borderColor),
                  ),
                  child: isSelected ? Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textLight.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No services found',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: AppTheme.borderColor),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '${_tempSelected.length}',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
