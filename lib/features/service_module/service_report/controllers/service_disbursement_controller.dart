import 'package:get/get.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_disbursement_report_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/services/service_disbursement_service_interface.dart';

class ServiceDisbursementController extends GetxController implements GetxService {
  final ServiceDisbursementServiceInterface serviceDisbursementServiceInterface;
  ServiceDisbursementController({required this.serviceDisbursementServiceInterface});

  ServiceDisbursementReportModel? _disbursementReportModel;
  ServiceDisbursementReportModel? get disbursementReportModel => _disbursementReportModel;

  Future<void> getDisbursementReport(int offset) async {
    ServiceDisbursementReportModel? disbursementReportModel = await serviceDisbursementServiceInterface.getDisbursementReport(offset);
    if (disbursementReportModel != null) {
      _disbursementReportModel = disbursementReportModel;
    }
    update();
  }
}
