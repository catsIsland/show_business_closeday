$(function () {
  $('#save_weekly_data').click(function () {
    var week_day_numbers = $('.week_day_numbers:checked');
    var repeat_weekly_days = $('#repeat_weekly_days').prop('checked');
    var weekly_close_days = [];
    if (week_day_numbers.length > 0) {
      $('.week_day_numbers:checked').each(function () {
        weekly_close_days.push($(this).val());
      })
    }

    if (jQuery.isEmptyObject(weekly_close_days) && repeat_weekly_days) {
      alert('定休日を設定してください');
      return
    }

    const data = {
      account_id: $('#account_id').val(),
      weekly_close_days: weekly_close_days,
      repeat_weekly_days: repeat_weekly_days
    }

    $.ajax({
      type: "post",
      url: '/save_weekly_data',
      data: JSON.stringify(data),
      contentType: 'application/json',
      dataType: "json",
      success: function (result) {
        if (result) {
          if (result.result) {
            location.reload();
          } else {
            alert("エラーが発生しました")
          }
        }
      }
    });
  })

  function day_checked(data, month_class, disable_flag) {
    data = data.split(',')
    $.each(data, function (index, val) {
      $('.' + month_class + ' #day_' + val).prop('checked', true);
      if (disable_flag) {
        $('.' + month_class + ' #day_' + val).attr('disabled', true);
        $('.' + month_class + ' #day_' + val).parent().attr('class', 'weekly_close_day');
      } else {
        $('.' + month_class + ' #day_' + val).parent().addClass('close_day');
      }
      
    });
  }

  var checkExist = setInterval(function () {
    if ($('#this_month_weekly_close_days').length) {
      day_checked($('#this_month_weekly_close_days').val(), 'this_month', true);
      day_checked($('#this_month_data').val(), 'this_month', false);
      day_checked($('#next_month_weekly_close_days').val(), 'next_month', true);
      day_checked($('#next_month_data').val(), 'next_month', false);

      clearInterval(checkExist);
    }
  }, 100); // check every 100ms

  $('#save_other_close_days').click(function () {
    // 今月分
    var this_month_checked = $('.this_month #calendar .other_day .calendar_checkbox:checked');
    var this_month_close_days = [];
    if (this_month_checked.length > 0) {
      $.each(this_month_checked, function() {
        this_month_close_days.push($(this).val());
      })
    }

    // 来月分
    var next_month_checked = $('.next_month #calendar .other_day .calendar_checkbox:checked');
    var next_month_close_days = [];
    if (next_month_checked.length > 0) {
      $.each(next_month_checked, function() {
        next_month_close_days.push($(this).val());
      })
    }

    const data = {
      account_id: $('#account_id').val(),
      this_month_close_days: this_month_close_days,
      next_month_close_days: next_month_close_days
    }

    $.ajax({
      type: "post",
      url: '/save_other_close_days',
      data: JSON.stringify(data),
      contentType: 'application/json',
      dataType: "json",
      success: function (result) {
        if (result) {
          if (result.result) {
            location.reload();
          } else {
            alert("エラーが発生しました");
          }
        }
      }
    });
  })
})