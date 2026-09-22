import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/models/vat_tax_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/service_module/store/domain/models/service_ai_model.dart';
import 'package:sixam_mart_store/features/service_module/store/domain/models/service_model.dart';
import 'package:sixam_mart_store/features/service_module/store/domain/models/service_variation_model.dart';
import 'package:sixam_mart_store/features/service_module/store/domain/services/service_service_interface.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';

class ServiceController extends GetxController implements GetxService {
  final ServiceServiceInterface serviceServiceInterface;
  ServiceController({required this.serviceServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Images
  XFile? _rawLogo;
  XFile? get rawLogo => _rawLogo;

  final List<XFile> _rawImages = [];
  List<XFile> get rawImages => _rawImages;

  final List<String> _savedImages = [];
  List<String> get savedImages => _savedImages;

  final List<String> _removeImageList = [];
  List<String> get removeImageList => _removeImageList;

  XFile? _pickedMetaImage;
  XFile? get pickedMetaImage => _pickedMetaImage;

  bool _isThumbnailValid = true;
  bool get isThumbnailValid => _isThumbnailValid;

  bool _isThumbnailRemoved = false;
  bool get isThumbnailRemoved => _isThumbnailRemoved;

  bool _isMetaImageValid = true;
  bool get isMetaImageValid => _isMetaImageValid;

  final List<bool> _rawImageValidList = [];
  bool isAdditionalImageValid(int index) => index < _rawImageValidList.length ? _rawImageValidList[index] : true;
  bool get hasInvalidAdditionalImages => _rawImageValidList.contains(false);

  // ── Discount / recommended
  final List<String?> _discountTypeList = ['percent', 'amount'];
  List<String?> get discountTypeList => _discountTypeList;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  bool _recommended = false;
  bool get recommended => _recommended;

  // ── Tags
  final List<String?> _tagList = [];
  List<String?> get tagList => _tagList;

  // ── Tax
  List<VatTaxModel>? _vatTaxList;
  List<VatTaxModel>? get vatTaxList => _vatTaxList;

  final List<int> _selectedVatTaxIdList = [];
  List<int> get selectedVatTaxIdList => _selectedVatTaxIdList;

  // ── Variations
  final List<ServiceVariationBodyModel> _variationList = [];
  List<ServiceVariationBodyModel> get variationList => _variationList;

  // ── AI state
  bool _titleLoading = false;
  bool get titleLoading => _titleLoading;

  bool _generalSetupLoading = false;
  bool get generalSetupLoading => _generalSetupLoading;

  bool _priceVariationLoading = false;
  bool get priceVariationLoading => _priceVariationLoading;

  bool _tagLoading = false;
  bool get tagLoading => _tagLoading;

  bool _seoLoading = false;
  bool get seoLoading => _seoLoading;

  bool _imageLoading = false;
  bool get imageLoading => _imageLoading;

  bool _suggestionLoading = false;
  bool get suggestionLoading => _suggestionLoading;

  ServiceSeoModel? _seoModel;
  ServiceSeoModel? get seoModel => _seoModel;

  ServiceTitleSuggestionModel? _titleSuggestionModel;
  ServiceTitleSuggestionModel? get titleSuggestionModel => _titleSuggestionModel;

  final List<String?> _keyWordList = [];
  List<String?> get keyWordList => _keyWordList;

  // ── Init / reset
  void initServiceData(ServiceModel? service) {
    _rawLogo = null;
    _rawImages.clear();
    _rawImageValidList.clear();
    _savedImages.clear();
    _removeImageList.clear();
    _pickedMetaImage = null;
    _isThumbnailValid = true;
    _isThumbnailRemoved = false;
    _isMetaImageValid = true;
    _discountTypeIndex = (service?.discountType == 'amount') ? 1 : 0;
    _recommended = service?.recommended == 1;
    _tagList.clear();
    _selectedVatTaxIdList.clear();
    _variationList.clear();

    if (service != null) {
      if (service.imagesFullUrl != null) {
        for (final img in service.imagesFullUrl!) {
          if (img != null) _savedImages.add(img);
        }
      }
      if (service.tags != null) {
        for (final tag in service.tags!) {
          if (tag.tag != null) _tagList.add(tag.tag);
        }
      }
      if (service.taxVatIds != null) {
        _selectedVatTaxIdList.addAll(service.taxVatIds!);
      }
      if (service.variations != null) {
        for (final variation in service.variations!) {
          _variationList.add(ServiceVariationBodyModel(
            nameController: TextEditingController(text: variation.name ?? ''),
            priceController: TextEditingController(text: variation.price != null && variation.price! > 0 ? variation.price.toString() : ''),
            discountController: TextEditingController(text: variation.discount != null && variation.discount! > 0 ? variation.discount.toString() : ''),
            discountTypeIndex: variation.discountType == 'amount' ? 1 : 0,
          ));
        }
      }
    }
  }

  // ── Images
  double get _maxFileSizeInByte => Get.find<SplashController>().configModel!.validationConfig!.maxFileSize * 1024 * 1024;

  Future<void> pickThumbnail() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _rawLogo = pickedFile;
      _isThumbnailValid = (await pickedFile.length()) <= _maxFileSizeInByte;
      _isThumbnailRemoved = false;
      update();
    }
  }

  void removeThumbnail() {
    _rawLogo = null;
    _isThumbnailValid = true;
    _isThumbnailRemoved = true;
    update();
  }

  Future<void> pickMetaImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedMetaImage = pickedFile;
      _isMetaImageValid = (await pickedFile.length()) <= _maxFileSizeInByte;
      update();
    }
  }

  Future<void> pickImages() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (final file in pickedFiles) {
        _rawImages.add(file);
        _rawImageValidList.add((await file.length()) <= _maxFileSizeInByte);
      }
      update();
    }
  }

  void removeImage(int index) {
    _rawImages.removeAt(index);
    if (index < _rawImageValidList.length) {
      _rawImageValidList.removeAt(index);
    }
    update();
  }

  void removeSavedImage(int index) {
    _removeImageList.add(_savedImages[index]);
    _savedImages.removeAt(index);
    update();
  }

  // ── Discount / recommended
  void setDiscountTypeIndex(int index, bool willUpdate) {
    _discountTypeIndex = index;
    if (willUpdate) update();
  }

  void toggleRecommended({bool willUpdate = true}) {
    _recommended = !_recommended;
    if (willUpdate) update();
  }

  // ── Tags
  void setTag(String tag, {bool isUpdate = true}) {
    if (tag.trim().isNotEmpty && !_tagList.contains(tag.trim())) {
      _tagList.add(tag.trim());
    }
    if (isUpdate) update();
  }

  void removeTag(int index) {
    _tagList.removeAt(index);
    update();
  }

  // ── Tax
  Future<void> getVatTaxList() async {
    _vatTaxList = await Get.find<StoreController>().storeServiceInterface.getVatTaxList();
    update();
  }

  void toggleVatTax(int id) {
    if (_selectedVatTaxIdList.contains(id)) {
      _selectedVatTaxIdList.remove(id);
    } else {
      _selectedVatTaxIdList.add(id);
    }
    update();
  }

  // ── Variations
  void addVariation() {
    _variationList.add(ServiceVariationBodyModel(
      nameController: TextEditingController(),
      priceController: TextEditingController(),
      discountController: TextEditingController(),
      discountTypeIndex: 0,
    ));
    update();
  }

  void removeVariation(int index) {
    _variationList.removeAt(index);
    update();
  }

  void setVariationDiscountType(int variationIndex, int discountTypeIndex) {
    _variationList[variationIndex].discountTypeIndex = discountTypeIndex;
    update();
  }

  // ── Submit
  Future<void> addService(ServiceModel service, bool isAdd) async {
    if (!_isThumbnailValid || !_isMetaImageValid || _rawImageValidList.contains(false)) {
      showCustomSnackBar('please_upload_lower_size_file'.tr);
      return;
    }

    _isLoading = true;
    update();

    Map<String, String> fields = {};
    final translations = service.translations ?? [];
    final Map<String, String> nameByLocale = {};
    final Map<String, String> shortByLocale = {};
    final Map<String, String> longByLocale = {};
    final List<String> orderedLocales = [];
    for (final t in translations) {
      final locale = t.locale ?? 'default';
      if (!orderedLocales.contains(locale)) orderedLocales.add(locale);
      if (t.key == 'name') {
        nameByLocale[locale] = t.value ?? '';
      } else if (t.key == 'short_description') {
        shortByLocale[locale] = t.value ?? '';
      } else if (t.key == 'long_description') {
        longByLocale[locale] = t.value ?? '';
      }
    }

    final Map<String, String> arrayFields = {};
    for (int i = 0; i < orderedLocales.length; i++) {
      final locale = orderedLocales[i];
      arrayFields['lang[$i]'] = locale;
      arrayFields['name[$i]'] = nameByLocale[locale] ?? '';
      arrayFields['short_description[$i]'] = shortByLocale[locale] ?? '';
      arrayFields['long_description[$i]'] = longByLocale[locale] ?? '';
    }
    fields.addAll(arrayFields);

    fields['category_id'] = service.categoryIds != null && service.categoryIds!.isNotEmpty ? (service.categoryIds![0].id ?? '') : '';
    if (service.categoryIds != null && service.categoryIds!.length > 1) {
      fields['sub_category_id'] = service.categoryIds![1].id ?? '';
    }
    if (service.storeCategoryId != null) {
      fields['store_category_id'] = service.storeCategoryId.toString();
    }
    fields['base_price'] = service.basePrice?.toString() ?? '0';
    fields['discount'] = service.discount?.toString() ?? '0';
    fields['discount_type'] = service.discountType ?? 'percent';
    fields['recommended'] = (service.recommended ?? 0).toString();

    // tags as comma-separated
    String tags = '';
    for (final tag in _tagList) {
      tags = tags + (tags.isEmpty ? '' : ',') + (tag ?? '').replaceAll(' ', '');
    }
    fields['tags'] = tags;

    // variations json
    if (_variationList.isNotEmpty) {
      fields['variations'] = jsonEncode(_variationList.map((v) => v.toJson()).toList());
    }

    // meta
    fields['meta_title'] = service.metaTitle ?? '';
    fields['meta_description'] = service.metaDescription ?? '';

    // tax
    if (Get.find<SplashController>().configModel!.systemTaxType == 'service_wise' && _selectedVatTaxIdList.isNotEmpty) {
      for (int i = 0; i < _selectedVatTaxIdList.length; i++) {
        fields['tax_ids[$i]'] = _selectedVatTaxIdList[i].toString();
      }
    }

    if (!isAdd && _removeImageList.isNotEmpty) {
      fields['removedImageKeys'] = _removeImageList.join(',');
    }

    Response response = await serviceServiceInterface.addService(
      service, _rawLogo, _pickedMetaImage, _rawImages, _savedImages, fields, isAdd,
    );

    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      Get.offAll(() => const DashboardScreen(pageIndex: 2));
      showCustomSnackBar(response.body['message'], isError: false);
    }
  }

  // ── AI
  int? get _moduleId => Get.find<ProfileController>().profileModel?.stores?[0].module?.id;

  Future<ServiceTitleDesModel?> generateTitleAndDescription({required String name, required String langCode}) async {
    _titleLoading = true;
    update();
    final title = await serviceServiceInterface.getAiTitle(name: name, langCode: langCode);
    final description = await serviceServiceInterface.getAiDescription(name: name, langCode: langCode);
    _titleLoading = false;
    update();
    if (title == null && description == null) return null;
    return ServiceTitleDesModel(title: title?.title, description: description?.description);
  }

  Future<ServiceGeneralSetupModel?> generateGeneralSetup({required String name, String? description}) async {
    _generalSetupLoading = true;
    update();
    final result = await serviceServiceInterface.getAiGeneralSetup(name: name, description: description, moduleId: _moduleId);
    _generalSetupLoading = false;
    update();
    return result;
  }

  Future<void> generateAndSetPriceVariation({required String name, String? description, required TextEditingController priceController}) async {
    _priceVariationLoading = true;
    update();
    final result = await serviceServiceInterface.getAiPriceVariation(name: name, description: description);
    if (result != null) {
      if (result.basePrice != null) {
        priceController.text = result.basePrice.toString();
      }
      if (result.variations != null && result.variations!.isNotEmpty) {
        _variationList.clear();
        for (final v in result.variations!) {
          _variationList.add(ServiceVariationBodyModel(
            nameController: TextEditingController(text: v.name ?? ''),
            priceController: TextEditingController(text: v.price != null && v.price! > 0 ? v.price.toString() : ''),
            discountController: TextEditingController(text: v.discount != null && v.discount! > 0 ? v.discount.toString() : ''),
            discountTypeIndex: v.discountType == 'amount' ? 1 : 0,
          ));
        }
      }
    }
    _priceVariationLoading = false;
    update();
  }

  Future<void> generateAndSetTags({required String name, String? description}) async {
    _tagLoading = true;
    update();
    final result = await serviceServiceInterface.getAiTags(name: name, description: description);
    if (result != null) {
      for (final tag in result.tags) {
        setTag(tag, isUpdate: false);
      }
    }
    _tagLoading = false;
    update();
  }

  Future<ServiceSeoModel?> generateSeo({required String name, String? description}) async {
    _seoLoading = true;
    update();
    _seoModel = await serviceServiceInterface.getAiSeo(name: name, description: description);
    _seoLoading = false;
    update();
    return _seoModel;
  }

  void setKeyWord(String? name, {bool willUpdate = true}) {
    if (name != null && name.trim().isNotEmpty) {
      _keyWordList.add(name.trim());
    }
    if (willUpdate) update();
  }

  void removeKeyWord(int index) {
    _keyWordList.removeAt(index);
    update();
  }

  void initializeKeyWords() {
    _keyWordList.clear();
  }

  Future<void> generateTitleSuggestions() async {
    _suggestionLoading = true;
    update();
    String keyWord = '';
    for (final element in _keyWordList) {
      keyWord = keyWord + (keyWord.isEmpty ? '' : ',') + (element ?? '');
    }
    _titleSuggestionModel = await serviceServiceInterface.getAiTitleSuggestions(keywords: keyWord);
    _suggestionLoading = false;
    update();
  }

  Future<Response> analyzeImage({required XFile image}) async {
    _imageLoading = true;
    update();
    Response response = await serviceServiceInterface.analyzeImage(image: image);
    _imageLoading = false;
    update();
    return response;
  }
}
