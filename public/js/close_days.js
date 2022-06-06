const close_days_week = ["日", "月", "火", "水", "木", "金", "土"];
const today = new Date();
let close_days_this_month;
let close_days_next_month;
let close_days_setting;
let close_days_element;
let close_days_title_text;
let element_id_flag;

// 月末だとずれる可能性があるため、1日固定で取得
var showDate = new Date(today.getFullYear(), today.getMonth(), 1);

// 初期表示
function show_close_days_calendar(account_id, url) {
  const close_days_acc_data = {
    account_id: account_id
  }
  $.ajax({
    type: "post",
    url: url,
    data: JSON.stringify(close_days_acc_data),
    contentType: 'application/json',
    dataType: "json",
    success: function (result) {
      if (result.result) {
        close_days_this_month = result.this_month;
        close_days_next_month = result.next_month;

        close_days_setting = result.setting;
        close_days_element = close_days_setting['element_name'];
        close_days_title_text = close_days_setting['title'];
        element_id_flag = close_days_setting['element_id_flag'];
        background_color = close_days_setting['background_color'];
        font_color = close_days_setting['font_color'];

        if (close_days_setting['publish']) {
          close_days_show_process(today, close_days_this_month);
        }
      }
    }
  });
}

function make_css() {
  style = '';
  style += 'background-color:' + background_color + ';';
  style += 'color:' + font_color + ';';
  return style
}

// 前の月表示
function close_days_prev() {
  showDate.setMonth(showDate.getMonth() - 1);
  close_days_show_process(showDate, close_days_this_month);
}

// 次の月表示
function close_days_next() {
  showDate.setMonth(showDate.getMonth() + 1);
  close_days_show_process(showDate, close_days_next_month);
}

// 次の月クリック
function close_day_prev_next_fun() {
  // class切り替え
  if ($(this)[0].className == 'close_month_next') {
    close_days_next();
    $(this).removeClass();
    $(this).addClass('close_month_prev');
  } else {
    close_days_prev();
    $(this).removeClass();
    $(this).addClass('close_month_next');
  }
}

// カレンダー表示
function close_days_show_process(date, close_days) {
  // 現在表示カレンダーの年月
  var year = date.getFullYear();
  var month = date.getMonth();

  // 初期div作成
  close_days_wrapper = document.createElement('div');
  close_days_title = document.createElement('div');
  close_days_header = document.createElement('div');
  close_days_calender = document.createElement('div');
  close_day_prev_next = document.createElement('div');

  // 全体要素
  $(close_days_wrapper).addClass('close_days_wrapper');
  $(close_days_title).addClass('close_days_title');
  $(close_days_title).html(close_days_title_text);

  // 年月タイトル
  $(close_days_header).attr('id', 'close_days_header');
  $(close_days_header).html(year + "年 " + (month + 1) + "月");

  // クラス、文言振り分け
  if (month == (today.getMonth())) {
    var close_month_class = 'close_month_next';
    var close_month_text = '翌月カレンダー';
  } else {
    var close_month_class = 'close_month_prev';
    var close_month_text = '今月カレンダー';
  }
  $(close_day_prev_next).attr('id', 'close_day_prev_next').addClass(close_month_class);
  $(close_day_prev_next).html(close_month_text);

  // カレンダー作成
  $(close_days_calender).attr('id', 'close_days_calender');
  var close_day_create_calendar = close_days_create_process(year, month, close_days);
  $(close_days_calender).html(close_day_create_calendar);

  // 全体に要素追加
  element_symbol = element_id_flag ? '#' : '.';
  $(close_days_wrapper).append([close_days_title, close_days_header, close_days_calender, close_day_prev_next]);
  $(element_symbol + close_days_element).html('');
  $(element_symbol + close_days_element).append(close_days_wrapper);

  // 翌月、今月クリックアクション 
  $(close_day_prev_next).bind('click', close_day_prev_next_fun);
}

// カレンダー作成
function close_days_create_process(year, month, close_days) {
  // 曜日
  var calendar = "<table><tr class='dayOfclose_days_week'>";
  for (var i = 0; i < close_days_week.length; i++) {
    calendar += "<th>" + close_days_week[i] + "</th>";
  }
  calendar += "</tr>";

  var count = 0;
  var startDayOfWeek = new Date(year, month, 1).getDay();
  var endDate = new Date(year, month + 1, 0).getDate();
  var lastMonthEndDate = new Date(year, month, 0).getDate();
  var row = Math.ceil((startDayOfWeek + endDate) / close_days_week.length);

  // 1行ずつ設定
  for (var i = 0; i < row; i++) {
    calendar += "<tr>";
    // 1colum単位で設定
    for (var j = 0; j < close_days_week.length; j++) {
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
        if (close_days.includes(count)) {
          calendar += "<td class='close_day' style='"+ make_css() +"'>" + count + "</td>";
        } else {
          calendar += "<td>" + count + "</td>";
        }
      }
    }
    calendar += "</tr>";
  }
  return calendar;
}