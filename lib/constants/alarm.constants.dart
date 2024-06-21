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
          "Đến giờ Cúng thời TÝ rồi 🕚🐭! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
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
      "fadeDuration": 5.0,
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
          "Đến giờ Cúng thời MẸO rồi 🕔🐱! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
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
          "Đến giờ Cúng thời NGỌ rồi 🕚🐴! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
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
          "Đến giờ Cúng thời DẬU rồi 🕔🐔! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
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
      "fadeDuration": 5.0,
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
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 3913,
      "dateTime":
          DateTime.now().copyWith(hour: 22, minute: 30, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Thức dậy chuẩn bị cúng thời TÝ 🥱🐭",
      "notificationBody": "Thời TÝ là một thời cúng quan trọng 🕚🐭! Hãy cố gắng thức dậy và giữ tỉnh táo trước khi cúng bạn nhé!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
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
      "notificationBody": "Thời TÝ là một thời cúng quan trọng 🕚🐭! Trong 15 phút tới bạn hãy cố gắng giữ tâm thanh tịnh và trong sạch để đảnh lễ Đức Chí Tôn khỏi điều tội lỗi nhé 😇!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
  ];
}
