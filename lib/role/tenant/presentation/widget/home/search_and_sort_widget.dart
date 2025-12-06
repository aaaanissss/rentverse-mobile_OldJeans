import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/role/tenant/presentation/cubit/search_and_sort/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/search_and_sort/state.dart';

class SearchAndSortWidget extends StatelessWidget {
  final List<String> categories;
  final void Function(String query, String category)? onChanged;

  const SearchAndSortWidget({
    super.key,
    this.categories = const ['All', 'House', 'Apartment', 'Townhouse'],
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchAndSortCubit(),
      child: BlocBuilder<SearchAndSortCubit, SearchAndSortState>(
        builder: (context, state) {
          final cubit = context.read<SearchAndSortCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SearchField(
                initialValue: state.query,
                onChanged: (q) {
                  cubit.updateQuery(q);
                  onChanged?.call(q, state.selectedType);
                },
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final c in categories) ...[
                      _FilterChipItem(
                        label: c,
                        selected: state.selectedType == c,
                        onTap: () {
                          cubit.selectType(c);
                          onChanged?.call(state.query, c);
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.teal, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? null : Colors.white,
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF00C2FF), Color(0xFF00E0C3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (selected)
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
