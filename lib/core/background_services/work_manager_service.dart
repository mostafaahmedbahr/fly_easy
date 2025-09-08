// class WorkMangerService {
//   static Workmanager myWorkManager = Workmanager();
//   @pragma('vm:entry-point')
//   static void callbackDispatcher() {
//     myWorkManager.executeTask((task, inputData) {
//       print("my First Background Task");
//       return Future.value(true);
//     });
//   }
//
//   static initWorkMangerService() {
//     myWorkManager.initialize(
//         callbackDispatcher
//     );
//     myWorkManager.registerPeriodicTask("1", "firstTask",
//         frequency: const Duration(hours: 2));
//   }
// }
