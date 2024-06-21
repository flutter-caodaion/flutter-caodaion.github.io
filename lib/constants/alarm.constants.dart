class AlarmConstants {
  static String focusModeAlarmMessage = "Bắt đầu tập trung";
  static String breakModeAlarmMessage = "Xả nghỉ";
  static int defaultFocusMins = 30;
  static int defaultBreakMins = 5;
  static double defaultVolume = 1.0;
  static String defaultAudio =
      "assets/audio/mixkit-uplifting-bells-notification-938.wav";
  static List defaultLoopAlarms = [
    {
      "id": 9931,
      "dateTime":
          DateTime.now().copyWith(hour: 23, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời TÝ 🐭",
      "notificationBody":
          "Đến giờ **Cúng thời TÝ** rồi 🕚🐭! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 5199,
      "dateTime":
          DateTime.now().copyWith(hour: 4, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Thức dậy ⏰",
      "notificationBody":
          "Đến giờ thức dậy rồi 🕓⏰! Chúc bạn có một ngày mới vui vẻ hạnh phúc 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 4884,
      "dateTime":
          DateTime.now().copyWith(hour: 5, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời MẸO 🐱",
      "notificationBody":
          "Đến giờ **Cúng thời MẸO** rồi 🕔🐱! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 834,
      "dateTime":
          DateTime.now().copyWith(hour: 11, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời NGỌ 🐴",
      "notificationBody":
          "Đến giờ **Cúng thời NGỌ** rồi 🕚🐴! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 292,
      "dateTime":
          DateTime.now().copyWith(hour: 17, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời DẬU 🐔",
      "notificationBody":
          "Đến giờ **Cúng thời DẬU** rồi 🕔🐔! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 4654,
      "dateTime":
          DateTime.now().copyWith(hour: 19, minute: 30, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Học Đạo 📑",
      "notificationBody":
          "Đến giờ Học Đạo rồi 📑! Chúc bạn có một buổi học tập hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 9691,
      "dateTime":
          DateTime.now().copyWith(hour: 21, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Đi ngủ 🥱",
      "notificationBody": "Đến giờ ngủ rồi 🕘🥱! Chúc bạn ngủ ngon 😴!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
  ];
  static List readLoopAlarms = [
    {
      "id": 3913,
      "dateTime":
          DateTime.now().copyWith(hour: 22, minute: 30, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Thức dậy chuẩn bị cúng thời TÝ 🥱🐭",
      "notificationBody": "**Thời TÝ là một thời cúng quan trọng 🕚🐭!** Hãy cố gắng thức dậy và giữ tỉnh táo trước khi cúng bạn nhé!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 7552,
      "dateTime":
          DateTime.now().copyWith(hour: 22, minute: 45, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Tịnh TÂM trước khi cúng thời TÝ 😇🐭",
      "notificationBody": "**Thời TÝ là một thời cúng quan trọng 🕚🐭!** Trong 15 phút tới bạn hãy cố gắng giữ tâm thanh tịnh và trong sạch để đảnh lễ Đức Chí Tôn khỏi điều tội lỗi nhé 😇!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 1732,
      "dateTime":
          DateTime.now().copyWith(hour: 4, minute: 45, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Tịnh TÂM trước khi cúng thời MẸO 😇🐱",
      "notificationBody": "**Thời MẸO chuẩn bị bắt đầu 🕔🐱!** Trong 15 phút tới bạn hãy cố gắng giữ tâm thanh tịnh và trong sạch để đảnh lễ Đức Chí Tôn khỏi điều tội lỗi nhé 😇!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 2371,
      "dateTime":
          DateTime.now().copyWith(hour: 10, minute: 45, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Tịnh TÂM trước khi cúng thời NGỌ 😇🐴",
      "notificationBody": "**Thời NGỌ chuẩn bị bắt đầu 🕚🐴!** Trong 15 phút tới bạn hãy cố gắng giữ tâm thanh tịnh và trong sạch để đảnh lễ Đức Chí Tôn khỏi điều tội lỗi nhé 😇!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 2743,
      "dateTime":
          DateTime.now().copyWith(hour: 16, minute: 45, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Tịnh TÂM trước khi cúng thời DẬU 😇🐔",
      "notificationBody": "**Thời DẬU chuẩn bị bắt đầu 🕔🐔!** Trong 15 phút tới bạn hãy cố gắng giữ tâm thanh tịnh và trong sạch để đảnh lễ Đức Chí Tôn khỏi điều tội lỗi nhé 😇!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 7273,
      "dateTime":
          DateTime.now().copyWith(hour: 19, minute: 15, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Chuẩn bị học tập",
      "notificationBody": "Gần đến giờ học tập, trong vòng 15 phút tới đây bạn hãy điều tiết thâm tâm ý chuyên nhất vào việc học sắp tới để buổi học trở nên hiệu quả hơn, và đừng quên **ĐỌC KINH VÀO HỌC** bạn nhé!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 4273,
      "dateTime":
          DateTime.now().copyWith(hour: 20, minute: 30, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Kết thúc học tập",
      "notificationBody": "Học đến đây là tốt rồi! Hãy giành 30 phút để **ĐỌC KINH ĐI NGỦ**, **QUÁN CHIẾU THÂN TÂM** và **GIẢI HẾT MUÔN VIỆC TRẦN GIAN** để đi vào giấc ngủ thật nhanh và hiệu quả bạn nhé!",
      "enableNotificationOnKill": false,
      "fadeDuration": 12.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
  ];
}
