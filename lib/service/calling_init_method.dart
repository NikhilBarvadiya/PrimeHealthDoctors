import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/models/calling_model.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/service/calling_service.dart';
import 'package:prime_health_doctors/service/permission_service.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/calling_view.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/incoming_call_dialog.dart';

class CallingInitMethod {
  static final CallingInitMethod _instance = CallingInitMethod._internal();

  factory CallingInitMethod() => _instance;

  CallingInitMethod._internal();

  CallData? _incomingCall;
  bool _isCallingViewOpen = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => Get.context!;

  Future<void> initData() async {
    final hasPermissions = await PermissionService.requestAllPermissions();
    if (!hasPermissions && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera and microphone permissions required')));
      return;
    }
    await CallingService().initialize();
    _setupFCMListeners();
  }

  void _setupFCMListeners() {
    CallingService().onIncomingCall = (callData) {
      _incomingCall = callData;
      showIncomingCallDialog(callData);
    };

    CallingService().onCallAccepted = (channelName) {
      if (_isCallingViewOpen) Get.back();
      _navigateToCalling(
        channelName,
        _incomingCall?.callType ?? CallType.video,
        AppointmentModel(
          id: _incomingCall?.senderId ?? "",
          patientName: _incomingCall?.senderName ?? "",
          patientEmail: 'rajesh.kumar@email.com',
          patientPhone: '+91 98765 43210',
          patientAvatar: '',
          date: '2024-01-15',
          time: '10:00 AM',
          service: 'Cardiology Consultation',
          serviceType: 'Specialist Consultation',
          notes: 'Follow-up for hypertension management',
          duration: '45 mins',
          consultationFee: 1500.0,
          paymentStatus: 'paid',
          status: 'confirmed',
          createdAt: DateTime(2024, 1, 10),
          isUrgent: false,
          patientAge: '45',
          patientGender: 'Male',
          medicalHistory: 'Hypertension, Type 2 Diabetes',
          fcmToken: _incomingCall?.senderFCMToken ?? "",
        ),
      );
    };

    CallingService().onCallRejected = (callId) {
      if (_isCallingViewOpen) {
        Get.back();
      } else {
        BuildContext? context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.pop(context);
        }
      }
      _incomingCall = null;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call was rejected')));
    };

    CallingService().onCallEnded = (senderName) {
      if (_isCallingViewOpen) Get.back();
      _incomingCall = null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$senderName ended the call')));
    };
  }

  void showIncomingCallDialog(CallData callData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return IncomingCallDialog(
          callData: callData,
          onAccept: () {
            Get.back();
            _navigateToCalling(
              callData.channelName,
              callData.callType,
              AppointmentModel(
                id: callData.senderId,
                patientName: callData.senderName,
                fcmToken: callData.senderFCMToken,
                patientEmail: 'rajesh.kumar@email.com',
                patientPhone: '+91 98765 43210',
                patientAvatar: '',
                date: '2024-01-15',
                time: '10:00 AM',
                service: 'Cardiology Consultation',
                serviceType: 'Specialist Consultation',
                notes: 'Follow-up for hypertension management',
                duration: '45 mins',
                consultationFee: 1500.0,
                paymentStatus: 'paid',
                status: 'confirmed',
                createdAt: DateTime(2024, 1, 10),
                isUrgent: false,
                patientAge: '45',
                patientGender: 'Male',
                medicalHistory: 'Hypertension, Type 2 Diabetes',
              ),
            );
          },
          onReject: () async {
            CallingService().closeNotification(callData.senderId.hashCode);
            final userData = await read(AppSession.userData);
            if (userData != null) {
              UserModel userModel = UserModel(
                id: "1",
                name: userData["name"] ?? 'Dr. John Smith',
                email: userData["email"] ?? 'john.smith@example.com',
                mobile: userData["mobile"] ?? '+91 98765 43210',
                password: userData["password"] ?? '********',
                specialty: userData["specialty"] ?? 'Orthopedic Physiotherapy',
                experienceYears: userData["experienceYears"] ?? 5,
                clinicName: userData["clinic"] ?? "PrimeHealth Clinic",
                clinicAddress: userData["clinicAddress"] ?? '123, Medical Street, City, State, 395009',
                referralCode: userData["referralCode"] ?? 'ABC',
                ownReferralCode: userData["ownReferralCode"] ?? 'AAA',
                registrationDate: userData["registrationDate"] ?? DateTime.now().toIso8601String(),
                fcmToken: userData["fcmToken"] ?? '',
              );
              CallingService().makeCall(
                callData.senderFCMToken,
                CallData(
                  senderId: userModel.id,
                  senderName: userModel.name,
                  senderFCMToken: userModel.fcmToken,
                  callType: callData.callType,
                  status: CallStatus.rejected,
                  channelName: callData.channelName,
                ),
              );
            }
            Get.back();
            _incomingCall = null;
            _isCallingViewOpen = false;
          },
        );
      },
    );
  }

  Future<void> _navigateToCalling(String channelName, CallType callType, AppointmentModel receiver) async {
    _isCallingViewOpen = true;
    final userData = await read(AppSession.userData);
    if (userData == null) return;
    UserModel userModel = UserModel(
      id: "1",
      name: userData["name"] ?? 'Dr. John Smith',
      email: userData["email"] ?? 'john.smith@example.com',
      mobile: userData["mobile"] ?? '+91 98765 43210',
      password: userData["password"] ?? '********',
      specialty: userData["specialty"] ?? 'Orthopedic Physiotherapy',
      experienceYears: userData["experienceYears"] ?? 5,
      clinicName: userData["clinic"] ?? "PrimeHealth Clinic",
      clinicAddress: userData["clinicAddress"] ?? '123, Medical Street, City, State, 395009',
      referralCode: userData["referralCode"] ?? 'ABC',
      ownReferralCode: userData["ownReferralCode"] ?? 'AAA',
      registrationDate: userData["registrationDate"] ?? DateTime.now().toIso8601String(),
      fcmToken: userData["fcmToken"] ?? '',
    );
    if (context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return CallingView(channelName: channelName, callType: callType, receiver: receiver, sender: userModel);
          },
        ),
      );
      _isCallingViewOpen = false;
    }
  }
}
