class AppString {
  AppString._privateConstructor();

  static final AppString _instance = AppString._privateConstructor();

  factory AppString() {
    return _instance;
  }

  final String punchOut = 'Punch Out';
  final String qr = 'QR';
  final String paymentLink = 'Payment Link';
  final String more = 'More';
  final String sales = 'Sales';
  final String paymentStatus = 'Payment Status';
  final String viewAll = 'View All';
  final String today = 'Today';
  final String noOfSales = 'No. of Sales';
  final String totalAmount = 'Total Amount';
  final String time = 'Time';
  final String amount = 'Amount';
  final String paidBy = 'Paid by';
  final String status = 'Status';
  final String poweredBy = 'Powered by';
  final String enterMobNumber = 'Enter your mobile number';
  final String mobNumberText = 'Mobile Number';
  final String mobNumberValidator = 'Enter valid mobile number';
  final String proceed = 'Proceed';
  final String verifyPhoneText = 'Verify your phone number';
  final String otpText = "We've sent an OTP to your number";
  final String resendOtp = "RESEND OTP";
  final String otpValText = "Please enter OTP";
  final String verify = "Verify";
  final String mpinText = 'Enter MPIN';
  final String changeMpinText = 'Enter your current MPIN code';
  final String cnfrmMpin = 'Confirm your MPIN code.\nEnter code again';
  final String punchIn = 'Punch In';
  final String filter = 'Filter';
  final String successful = 'Successful';
  final String failed = 'Failed';
  final String pending = 'Pending';
  final String cancel = 'Cancel';
  final String apply = 'Apply';
  final String paymentReceived = 'Payment Received';
  final String paymentDetails = 'Payment Details';
  final String paymentProcessing = 'Payment Processing';
  final String from = 'From';
  final String utrNo = 'UTR/RRN Number';
  final String orderId = 'Invoice No.';
  final String transId = 'Transaction Id';
  final String remarks = 'Remarks';
  final String cash = 'Cash';
  final String checkStatus = 'Check Status';
  final String scanUtr = 'Scan UTR';
  final String staticQr = 'Static QR';
  final String attendance = 'Attendance';
  final String accountSettings = 'Account Settings';
  final String aboutUs = 'About Us';
  final String contactUs = 'Contact Us';
  final String plzConfirmCheckOutUWillBeLoggedOut =
      'Please confirm checkout\nYou will be logged out.';
  final String ok = 'Ok';
  final String notification = 'Notifications';
  final String amountVal = 'Please enter amount';
  final String sendPaymentLInk = 'Send Payment Link';
  final String changeMpin = 'Change MPIN Code';
  final String termsAndCondition = 'Terms & Conditions';
  final String contactus =
      'Feel free to contact us. We will get back to you\nas soon as we can.';
  final String settlements = 'Settlements';
  final String liveStatus = 'Live Status';
  final String duration = 'Duration';
  final String version = 'Version';
  final String yesterday = 'Yesterday';
  final String thisWeek = 'This Week';
  final String thisMonth = 'This Month';
  final String thisYear = 'This Year';
  final String customDate = 'Custom Date';
  final String continueText = 'Continue';
  final String utrNum = 'UTR Number';
  final String utrVal = 'Please enter UTR number';
  final String scanQrText =
      'Scan QR to make the payment using any\npayment app';
  final String home = 'Home';
  final String downloadQr = 'Download QR';
  final String transactionId = 'Transaction ID';
  final String success = 'Success';
  final String permissionRequired = 'Permission Required';
  final String permissionDes =
      'Please select "Allow" to avail all of our services. You can go to settings->SwinkPay app-> Permissions to enable the access and continue with the registration process';
  final String lastCheckinMsg = 'Last Check in was at';
  final String capture = 'Capture';
  final String registrationErrorText =
      'Mobile number not registered with SwinkPay. For any queries, reach out to ';
  final String or = 'or';
  final String okay = 'Okay';
  final String okayCaps = 'OKAY';
  final String loading = 'Loading';
  final String plzSelectThePaymentStatus = 'Please select the Payment Status';
  final String aboutUsContent =
      'SwinkPay Fintech is a cloud hosted SaaS company engaged in the business of providing digital payment solutions. Our solution simplifies retail transaction for better Customer experience and efficient payment back-office management, by focusing on servicing merchants’ payment, loyalty, billing and reconciliation requirements. We provide merchants with daily invoice-wise reconciliation and help merchants track each invoice from billing to ‘credit in bank’ \n \nWe are a PCI-DSS certified and RBI CERT-In complaint (covering Data Protection and Data Residency norms).We are not a Payment Aggregator, however our merchant services include self on-boarding of merchants with multiple Payment Aggregators, facilitating payment acceptance through multiple channels of payments connected with Payment Aggregators, Facilitating KYC between Merchants and Payment Aggregators, Facilitate Agreements between Payment Aggregators and Merchants, provide pre-negotiated fair prices MDR / Platform fees for merchants, providing consolidated dashboard to merchants , designing, developing, hosting and operating white label merchant applications. Merchants execute Agreements, Terms and Conditions and Privacy Policy Agreements directly with Payment Aggregators.\n\nOur services have demonstrated back-office efficiencies, staff optimization, improved profitability, and better controllership for our customers.';
  final String noData = 'No data found..!!!';
  final String noSales = 'No Sales';
  final String somethingWentWrongPlzTryAgain =
      'SomeThing went wrong. Please try again.';
  final String registrationSuccessMsg =
      'Your new mobile number is successfully updated.';
  final String go = 'Go';
  final String done = 'Done';

  static String getStatus({required dynamic status}) {
    try {
      String data = status.toString();
      var st = {"0": 'Processing', "1": 'Success', "2": 'Failed'};
      return st[data] ?? '-';
    } catch (_) {
      return '-';
    }
  }

  static String getPaymentStatusText({required dynamic status}) {
    try {
      String data = status.toString();
      var st = {
        "0": 'Payment Processing',
        "1": 'Payment Received',
        "2": 'Payment Failed'
      };
      return st[data] ?? '-';
    } catch (_) {
      return '-';
    }
  }
}
