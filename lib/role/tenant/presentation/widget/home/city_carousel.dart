import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/city/cubit.dart';
import '../../cubit/city/state.dart';

class CityCarousel extends StatelessWidget {
  const CityCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CityCubit()..load(),
      child: BlocBuilder<CityCubit, CityState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.error != null) {
            return SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Failed to load cities',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            );
          }

          if (state.cities.isEmpty) {
            return const SizedBox(height: 150);
          }

          return CarouselSlider.builder(
            itemCount: state.cities.length,
            itemBuilder: (context, index, realIndex) {
              final city = state.cities[index];
              return _CityCard(city: city);
            },
            options: CarouselOptions(
              height: 150,
              viewportFraction: 0.88,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                context.read<CityCubit>().setIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final City city;

  const _CityCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: city.image,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: Colors.grey.shade200),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${city.propertyCount} properties',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
