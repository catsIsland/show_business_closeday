const week = ["日", "月", "火", "水", "木", "金", "土"];
const today = new Date();
// 月末だとずれる可能性があるため、1日固定で取得
var showDate = new Date(today.getFullYear(), today.getMonth(), 1);

// 初期表示
window.onload = function () {
  showProcess(today);
};

// ２ヶ月分のカレンダー表示
function showProcess(date, classname) {
  // 今月
  var year = date.getFullYear();
  var month = date.getMonth();
  document.querySelector('.this_month #header').innerHTML = year + "年 " + (month + 1) + "月";
  var calendar = createProcess(year, month);
  document.querySelector('.this_month #calendar').innerHTML = calendar;

  // 来月
  showDate.setMonth(showDate.getMonth() + 1);
  var next_year = showDate.getFullYear();
  var next_month = showDate.getMonth();
  document.querySelector('.next_month #header').innerHTML = next_year + "年 " + (next_month + 1) + "月";
  var calendar = createProcess(next_year, next_month);
  document.querySelector('.next_month #calendar').innerHTML = calendar;

}

// カレンダー作成
function createProcess(year, month) {
  // 曜日
  var calendar = "<table><tr class='dayOfWeek'>";
  for (var i = 0; i < week.length; i++) {
    calendar += "<th>" + week[i] + "</th>";
  }
  calendar += "</tr>";

  var count = 0;
  var startDayOfWeek = new Date(year, month, 1).getDay();
  var endDate = new Date(year, month + 1, 0).getDate();
  var lastMonthEndDate = new Date(year, month, 0).getDate();
  var row = Math.ceil((startDayOfWeek + endDate) / week.length);

  // 1行ずつ設定
  for (var i = 0; i < row; i++) {
    calendar += "<tr>";
    // 1colum単位で設定
    for (var j = 0; j < week.length; j++) {
      if (i == 0 && j < startDayOfWeek) {
        // 1行目で1日まで先月の日付を設定
        calendar += "<td class='disabled'>" + (lastMonthEndDate - startDayOfWeek + j + 1) + "</td>";
      } else if (count >= endDate) {
        // 最終行で最終日以降、翌月の日付を設定
        count++;
        calendar += "<td class='disabled'>" + (count - endDate) + "</td>";
      } else {
        // 当月の日付を曜日に照らし合わせて設定
        count++;
        var today_class;
        if (year == today.getFullYear() &&
          month == (today.getMonth()) &&
          count == today.getDate()) {
          today_class = 'today';
        } else {
          today_class = '';
        }
        calendar += "<td class='" + today_class + " other_day'><span class='calendar_td_text'>" + count + "</span><input type='checkbox' class='calendar_checkbox' id='day_"+ count +"' value='" + count + "'></td>";
      }
    }
    calendar += "</tr>";
  }
  return calendar;
}