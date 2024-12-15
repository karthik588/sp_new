import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swinpay/view/widgets/loadingPrompt.dart';
import 'package:swinpay/view/widgets/toastMessage.dart';
import '../../../functions/dashboard_function.dart';
import '../dashboard/cash_mode_prompt.dart';

class ScanUtrPage extends StatefulWidget {
  const ScanUtrPage({Key? key}) : super(key: key);

  @override
  State<ScanUtrPage> createState() => _ScanUtrPageState();
}

class _ScanUtrPageState extends State<ScanUtrPage> {
  RxBool loading = true.obs;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextRecognizer textRecognizer = TextRecognizer();
  XFile? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    loading(true);
    var cams = await availableCameras();
    _controller = CameraController(
      cams.first,
      enableAudio: false,
      ResolutionPreset.veryHigh,
    );
    _initializeControllerFuture = _controller.initialize().then((value) {
      loading(false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
     textRecognizer.close();
    super.dispose();
  }



  Future<void> captureImage() async {
    try {
      LoadingPrompt().show();
      await _initializeControllerFuture;
      XFile imageFile = await _controller.takePicture();
      RecognizedText recognisedText = await textRecognizer.processImage(InputImage.fromFilePath(imageFile.path));
      String extractedText = recognisedText.text;
      RegExp regex = RegExp(r'\b\d{12}\b');
      Match? match = regex.firstMatch(extractedText);
      Navigator.pop(Get.context!);
      if (match != null) {
        String extractedNumber = match.group(0)!;
        DashboardFunction().amount.clear();
        CashModePrompt().show(
            controller: DashboardFunction().amount,
            onTapContinue: () async {
              Navigator.pop(Get.context!);
              await DashboardFunction().checkPaymentStatus(
                  isDynamicStatusCheck: false,
                  utr: extractedNumber,
                  amount: DashboardFunction().amount.text);
            });
      } else {
        ToastMessage().showToast(content: 'Oops! Something went wrong. Please try scanning again');
      }
    } catch (e) {
      Navigator.pop(Get.context!);
      ToastMessage().showToast(content: 'Oops! Something went wrong. Please try scanning again');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => loading.value
        ? const Center(child: CupertinoActivityIndicator())
        : _scanner());
  }

  Widget _scanner() => CameraPreview(
    _controller,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back()),
          const Spacer(),
          Container(
            width: double.infinity,
            margin:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Buttons().raisedButton(
                textStyle: const TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                buttonText: AppString().capture,
                onTap: () {
                  captureImage();
                }),
          ),
        ],
      ),
    ),
  );
}
