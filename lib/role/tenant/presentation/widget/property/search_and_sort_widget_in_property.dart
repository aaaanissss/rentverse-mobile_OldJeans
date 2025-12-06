import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/role/tenant/presentation/cubit/search_and_sort_for_property.dart/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/search_and_sort_for_property.dart/state.dart';

class SearchAndSortWidgetForProperty extends StatelessWidget {
  const SearchAndSortWidgetForProperty({
    super.key,
    this.categories = const ['All', 'House', 'Apartment', 'Townhouse'],
    this.onChanged,
  });

  final List<String> categories;
  final void Function(String query, String category)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchAndSortForPropertyCubit(),
      child:
          BlocBuilder<
            SearchAndSortForPropertyCubit,
            SearchAndSortForPropertyState
          >(
            builder: (context, state) {
              final cubit = context.read<SearchAndSortForPropertyCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SearchField(
                          initialValue: state.query,
                          onChanged: (q) {
                            cubit.updateQuery(q);
                            onChanged?.call(q, state.selectedType);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: cubit.toggleFilter,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C2FF), Color(0xFF00E0C3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune, color: Colors.white),
                        ),
                      ),
                    ],
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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state.showFilter
                        ? Padding(
                            key: const ValueKey('filters'),
                            padding: const EdgeInsets.only(top: 14),
                            child: _FilterSheet(
                              selectedBedroom: state.selectedBedroom,
                              onBedroomSelected: cubit.setBedroom,
                              sizeValue: state.sizeValue,
                              onSizeChanged: cubit.setSize,
                              priceValue: state.priceValue,
                              onPriceChanged: cubit.setPrice,
                              selectedFeatures: state.selectedFeatures,
                              onToggleFeature: cubit.toggleFeature,
                              onReset: cubit.resetFilters,
                            ),
                          )
                        : const SizedBox.shrink(),
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
          const _GradientIcon(Icons.search, size: 22),
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

class _FilterSheet extends StatelessWidget {
  final int selectedBedroom;
  final ValueChanged<int> onBedroomSelected;
  final double sizeValue;
  final ValueChanged<double> onSizeChanged;
  final double priceValue;
  final ValueChanged<double> onPriceChanged;
  final Set<String> selectedFeatures;
  final ValueChanged<String> onToggleFeature;
  final VoidCallback onReset;

  const _FilterSheet({
    required this.selectedBedroom,
    required this.onBedroomSelected,
    required this.sizeValue,
    required this.onSizeChanged,
    required this.priceValue,
    required this.onPriceChanged,
    required this.selectedFeatures,
    required this.onToggleFeature,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final featureOptions = ['Kitchen', 'Wifi', 'Swimming Pool', 'TV', 'Washer'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            'Location',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                _GradientIcon(Icons.location_on, size: 18),
                SizedBox(width: 8),
                Text(
                  'Kuala Lumpur, Malaysia',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Bedrooms', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final bed in [0, 1, 2, 3, 4, 5])
                _pill(
                  label: bed == 0 ? 'Any' : '$bed',
                  selected: selectedBedroom == bed,
                  onTap: () => onBedroomSelected(bed),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Size (sqft)',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const _GradientSliderTrackShape(),
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: appPrimaryColor,
              overlayColor: appPrimaryColor.withOpacity(0.12),
            ),
            child: Slider(
              value: sizeValue,
              min: 200,
              max: 2000,
              divisions: 18,
              label: '${sizeValue.toStringAsFixed(0)} sqft',
              onChanged: onSizeChanged,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Price Range',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const _GradientSliderTrackShape(),
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: appPrimaryColor,
              overlayColor: appPrimaryColor.withOpacity(0.12),
            ),
            child: Slider(
              value: priceValue,
              min: 1000000,
              max: 20000000,
              divisions: 19,
              label: 'Rp ${priceValue.toStringAsFixed(0)}',
              onChanged: onPriceChanged,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Features', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in featureOptions)
                _pill(
                  label: f,
                  selected: selectedFeatures.contains(f),
                  onTap: () => onToggleFeature(f),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appPrimaryColor, width: 1.4),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: appPrimaryColor,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onReset,
                    child: const Text('Reset Filter'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: customLinearGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Apply Filter'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? customLinearGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
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
            color: selected ? Colors.white : appPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  const _GradientIcon(this.icon, {required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          customLinearGradient.createShader(Rect.fromLTWH(0, 0, size, size)),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class _GradientSliderTrackShape extends RoundedRectSliderTrackShape {
  const _GradientSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    double additionalActiveTrackHeight = 2,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    Offset? secondaryOffset,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      offset: offset,
    );

    final activePaint = Paint()
      ..shader = customLinearGradient.createShader(trackRect);

    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey;

    final leftRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    final rightRect = Rect.fromLTRB(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(leftRect, Radius.circular(trackRect.height / 2)),
      activePaint,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(rightRect, Radius.circular(trackRect.height / 2)),
      inactivePaint,
    );
  }
}
