import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/paginated_list_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/custom_service_request_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/custom_service_request_card_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/shimmer/custom_service_request_list_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomServiceListViewWidget extends StatelessWidget {
  final List<CustomServiceRequestModel>? requests;
  final bool newRequest;
  final int? totalSize;
  final int? offset;
  final ScrollController scrollController;
  final Future<void> Function(int? offset) onPaginate;
  const CustomServiceListViewWidget({
    super.key, required this.requests, required this.newRequest, required this.totalSize,
    required this.offset, required this.scrollController, required this.onPaginate,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => onPaginate(1),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraSmall),
        child: requests == null
            ? const CustomServiceRequestListShimmerWidget()
            : requests!.isEmpty
                ? Center(
                    child: Text(
                      newRequest ? 'no_custom_service_request_found'.tr : 'no_bid_placed_yet'.tr,
                      style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                    ),
                  )
                : SingleChildScrollView(
                    controller: scrollController,
                    child: PaginatedListWidget(
                      scrollController: scrollController,
                      onPaginate: onPaginate,
                      totalSize: totalSize,
                      offset: offset,
                      productView: ListView.builder(
                        itemCount: requests!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => CustomServiceRequestCardWidget(request: requests![index], newRequest: newRequest),
                      ),
                    ),
                  ),
      ),
    );
  }
}
