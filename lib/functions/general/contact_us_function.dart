import 'package:url_launcher/url_launcher.dart';

import '../../global/app_util.dart';
import '../../models/emailSenderModel.dart';
import '../../view/widgets/toastMessage.dart';

class ContactFunction {
  static final ContactFunction _contactFunction = ContactFunction._internal();

  factory ContactFunction() {
    return _contactFunction;
  }

  ContactFunction._internal();

  void call({required String number}) {
    number = 'tel:$number';
    launchURL(url: number);
  }

  Future<void> launchURL(
      {required String url,
      Function? onFailed,
      LaunchMode launchMode = LaunchMode.platformDefault}) async {
    try {
      await launchUrl(Uri.parse(url), mode: launchMode);
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
      AppUtil.printData('Could not launch $e');
      AppUtil.printData('Could not launch $url');
    }
  }

  Future<void> sendEmail({
    required List<String> recipients,
    String subject = '',
    List<String>? cc,
    List<String>? bcc,
    String body = '',
  }) async {
    try {
      final email = Email(
        recipients: recipients,
        subject: subject,
        cc: cc ?? [''],
        bcc: bcc ?? [''],
        body: body,
        //attachmentPaths: ['/path/to/attachment.zip'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (_) {
      AppUtil.printData('Could not launch $_');
      ToastMessage().showToast(content: 'Please Configure the default Mail app to proceed');
    }
  }
}
