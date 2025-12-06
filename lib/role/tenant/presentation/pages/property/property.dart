import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/common/widget/custom_app_bar.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/property/domain/usecase/get_properties_usecase.dart';
import 'package:rentverse/role/tenant/presentation/cubit/get_user/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/get_user/state.dart';
import 'package:rentverse/role/tenant/presentation/cubit/list_property/cubit.dart';
import 'package:rentverse/role/tenant/presentation/widget/property/list_property.dart';
import 'package:rentverse/role/tenant/presentation/widget/property/search_and_sort_widget_in_property.dart';

class TenantPropertyPage extends StatelessWidget {
  const TenantPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetUserCubit(sl())..load(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5),

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: BlocBuilder<GetUserCubit, GetUserState>(
              builder: (context, state) {
                final displayName = state.user?.name?.isNotEmpty == true
                    ? state.user!.name!
                    : 'User';
                return CustomAppBar(displayName: displayName);
              },
            ),
          ),
          body: BlocProvider(
            create: (_) =>
                ListPropertyCubit(sl<GetPropertiesUseCase>())..load(),

            child: NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll.metrics.pixels >=
                        scroll.metrics.maxScrollExtent - 120 &&
                    scroll is ScrollUpdateNotification) {
                  final cubit = scroll.context?.read<ListPropertyCubit>();
                  cubit?.loadMore();
                }
                return false;
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SearchAndSortWidgetForProperty(),
                      const SizedBox(height: 12),
                      const ListPropertyWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
