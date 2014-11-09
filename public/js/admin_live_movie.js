(function() {
  $(function() {
    var arrayId, kashi, time, video;
    video = $("#liveVideo").get(0);
    console.log(video);
    time = void 0;
    arrayId = 0;
    kashi = new Array("伝えたいことがあるの　ここに記してたいから", "どうしてもどうにかしても　夢じゃないって叫ぼう", "", "本物だと　信じていた　空は天井の落書きで", "いつの間にか　狭い部屋に　閉じ込められてたの", "自分の場所　ここじゃないんだって", "未来思う強さが　あれば本当の空はほら　見えるから", "伝えたいことがあるの　この気持ち形にして", "まっすぐに今すぐに　理想の自分になる！", "好きなことをずっと　ここに記してたいから", "どうしてもどうにかしても　夢じゃないって叫ぼう", "", "本物だと　言い聞かせた　作り物の明日とかを", "捨てる勇気も必要だよ　前に向かうために", "自分の声　響くところへ", "明日も抗っていける　パワーを絶やさないでいけば　叶うから", "伝えたいことがあるの　この気持ち形にして", "まっすぐに今すぐに　理想の自分になる！", "好きなことをずっと　ここに記してたいから", "どうしてもどうにかしても　夢じゃないって叫ぼう", "", "デタラメでも　夢見た　理想なら捨てちゃダメなんだよ", "小さかった　私達の想い　少しずつ育てて", "奏でたいことがあるよ　描きたいことがあるよ", "", "伝えたいことがあるの　この気持ち形にして", "まっすぐに今すぐに　理想の自分になる！", "好きなことをずっと　ここに記してたいから", "どうしてもどうにかしても　夢じゃないって叫ぼう", "");
    $("#play").click(function() {
      video.play();
      return console.log("play");
    });
    $("#pause").click(function() {
      return video.pause();
    });
    $("#upV").click(function() {
      return video.volume = video.volume + 0.25;
    });
    $("#downV").click(function() {
      return video.volume = video.volume - 0.25;
    });
    video.addEventListener("timeupdate", function() {
      time = parseFloat(Math.round(video.currentTime * 10) / 10);
      $("#ichi").html(time);
      $("#liveBc2").html(Math.round(time));
      if (time < 6.2) {
        arrayId = 0;
      } else if (time < 14.6) {
        arrayId = 1;
      } else if (time < 23.3) {
        arrayId = 2;
      } else if (time < 34.2) {
        arrayId = 3;
      } else if (time < 43.5) {
        arrayId = 4;
      } else if (time < 49) {
        arrayId = 5;
      } else if (time < 63.6) {
        arrayId = 6;
      } else if (time < 69.5) {
        arrayId = 7;
      } else if (time < 74.8) {
        arrayId = 8;
      } else if (time < 80.4) {
        arrayId = 9;
      } else if (time < 88.4) {
        arrayId = 10;
      } else if (time < 100) {
        arrayId = 11;
      } else if (time < 111) {
        arrayId = 12;
      } else if (time < 120.5) {
        arrayId = 13;
      } else if (time < 125.9) {
        arrayId = 14;
      } else if (time < 140) {
        arrayId = 15;
      } else if (time < 146) {
        arrayId = 16;
      } else if (time < 151) {
        arrayId = 17;
      } else if (time < 156.9) {
        arrayId = 18;
      } else if (time < 165.1) {
        arrayId = 19;
      } else if (time < 187) {
        arrayId = 20;
      } else if (time < 198.5) {
        arrayId = 21;
      } else if (time < 210) {
        arrayId = 22;
      } else if (time < 218) {
        arrayId = 23;
      } else if (time < 224) {
        arrayId = 24;
      } else if (time < 230) {
        arrayId = 25;
      } else if (time < 235.5) {
        arrayId = 26;
      } else if (time < 241) {
        arrayId = 27;
      } else if (time < 249) {
        arrayId = 28;
      } else {
        if (time < 260) {
          arrayId = 29;
        }
      }
      $("#kashi").html(kashi[arrayId]);
    });
  });

}).call(this);
