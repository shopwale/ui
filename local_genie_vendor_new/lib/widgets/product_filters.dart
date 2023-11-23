import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/order_status_modal.dart';
import 'package:local_genie_vendor/widgets/border_button.dart';
import 'package:local_genie_vendor/widgets/circular_progress.dart';

class ProductFilter extends ConsumerStatefulWidget {
  ProductFilter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductFilterState();
}

class _ProductFilterState extends ConsumerState<ProductFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  Map<String, dynamic> _selectedFilter = {
    "categories": [],
    "subCategories": [],
    "colors": "",
    "sizes": "",
    "sortBy": "asc",
    "sort": "",
    "priceRange": "300 - 3000"
  };
  bool isLoading = false;

  RangeValues _currentRangeValues = const RangeValues(500, 3000);
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInSine);

    controller.forward();
    // if (mounted) setInitialFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setInitialFilters();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    scaleAnimation.removeStatusListener((status) {});
  }

  setInitialFilters() async {
    // final filters = jsonDecode(jsonEncode(ref.read(filtersProvider)));
    // final subCategories = await getSubCategories();
    // filters['subCategories'] = subCategories;
    // setState(() {
    //   _selectedFilter = filters;
    // });
  }

  Widget textWithBorder(String text, bool selected) {
    return Container(
      decoration: BoxDecoration(
        color: selected == true ? yellow : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: yellow, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget textWithBorderAndIcon(String text, bool selected, Icon? icon) {
    return Container(
      decoration: BoxDecoration(
        color: selected == true ? yellow : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: yellow, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Wrap(
        // alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 10),
          ),
          if (icon != null) icon,
        ],
      ),
    );
  }

  Widget getOrderStatus() {
    return Text("data");
    //   final categories = ref.watch(orderStatusProvider);
    //   return categories.when(
    //     data: (data) {
    //       var _data = data.toList();
    //       _data.removeAt(0);
    //       return getFilters(
    //         'Categories',
    //         _data,
    //         'categories',
    //         multiple: true,
    //       );
    //     },
    //     error: (Object error, StackTrace stackTrace) {
    //       return CircularProgress();
    //     },
    //     loading: () {
    //       return CircularProgress();
    //     },
    //   );
  }

  // Widget getSubCategories() {
  //   var orderStatus = ref.watch(filterOrderStatusSelectedProvider);
  //   if (orderStatus.isEmpty) return const Text("");
  //   var subCategories =
  //       ref.watch(subCategoriesForProductsProvider(orderStatus));
  //   return subCategories.when(
  //     data: (data) {
  //       return getFilters(
  //         'Sub Categories',
  //         data,
  //         'subCategories',
  //         multiple: true,
  //       );
  //     },
  //     error: (Object error, StackTrace stackTrace) {
  //       return CircularProgress();
  //     },
  //     loading: () {
  //       return CircularProgress();
  //     },
  //   );
  // }

  Widget getSortBy() {
    final list = [
      OrderStatusM.fromJson({"name": "Name", "_id": "name"}),
      OrderStatusM.fromJson({"name": "New Arrivals", "_id": "_id"}),
      OrderStatusM.fromJson({"name": "Price", "_id": "after_discount"}),
      OrderStatusM.fromJson({"name": "Discount", "_id": "total_discount"}),
    ].toList();
    return getFilters('Sort Using', list, 'sort', sort: true);
  }

  Widget getPriceRange() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price Range",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        RangeSlider(
          values: _currentRangeValues,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            if (values.start.round() == values.end.round()) return;
            if (values.start.round() + 400 >= values.end.round()) return;
            _selectedFilter['priceRange'] =
                "${values.start.floor()} - ${values.end.floor()}";
            setState(() {
              _currentRangeValues = values;
              _selectedFilter = _selectedFilter;
            });
          },
        ),
        Center(
          child: Text("Rs ${_selectedFilter['priceRange']}"),
        ),
      ],
    );
  }

  Widget getFilters(String title, List<dynamic> filters, String field,
      {bool multiple = false, bool sort = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: filters.map((e) {
            return InkWell(
              onLongPress: () {
                _selectedFilter[field] = multiple ? [] : "";
                _selectedFilter['sortBy'] = "asc";
              },
              onTap: () {
                if (sort) {
                  if (_selectedFilter[field] == e.id) {
                    _selectedFilter['sortBy'] =
                        _selectedFilter['sortBy'] == "asc" ? "des" : "asc";
                  } else {
                    _selectedFilter[field] = e.id;
                    _selectedFilter['sortBy'] = "asc";
                  }
                } else {
                  if (!multiple) {
                    _selectedFilter[field] =
                        _selectedFilter[field] == e.id ? "" : e.id;
                  } else {
                    if (_selectedFilter[field].contains(e.id) != true) {
                      _selectedFilter[field].add(e.id);
                    } else {
                      _selectedFilter[field].remove(e.id);
                    }
                  }
                  if (field == "categories") {
                    print("categories: " + _selectedFilter[field].join(","));
                    // ref.read(filterOrderStatusSelectedProvider.notifier).state =
                    //     _selectedFilter[field].join(",");
                  }
                }
                setState(() {
                  _selectedFilter = _selectedFilter;
                });
              },
              child: sort
                  ? textWithBorderAndIcon(
                      e.name,
                      e.id == _selectedFilter[field],
                      e.id == _selectedFilter[field]
                          ? Icon(
                              _selectedFilter['sortBy'] == "asc"
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 14,
                            )
                          : null)
                  : textWithBorder(
                      e.name,
                      !multiple
                          ? e.id == _selectedFilter[field]
                          : _selectedFilter[field].contains(e.id),
                    ),
            );
          }).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        alignment: Alignment.bottomCenter,
        scale: scaleAnimation,
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              InkWell(
                child: Container(
                  color: Colors.transparent,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getOrderStatus(),
                      const SizedBox(height: 30),
                      // getSubCategories(),
                      // const SizedBox(height: 30),
                      getSortBy(),
                      const SizedBox(height: 30),
                      getPriceRange(),
                      const SizedBox(height: 30),
                      CustomBorderButton(
                        context,
                        text: "Search",
                        onPressed: () {
                          // var orderStatus =
                          //     ref.read(orderStatusSelectedProvider);
                          // ref.read(productStateProvider.notifier).getProducts(
                          //       orderStatusId: orderStatus.id,
                          //       resetPage: true,
                          //       options: _selectedFilter,
                          //     );
                          // ref.read(filtersProvider.notifier).state =
                          //     _selectedFilter;
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
