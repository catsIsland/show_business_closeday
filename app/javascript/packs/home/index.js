$(function () {
  var this_month_checked = $('.this_month #calendar .calendar_checkbox:checked');
  var weekly_close_days = [];

  $('#save_weekly_data').click(function () {
    var week_day_numbers = $('.week_day_numbers:checked');
    if (week_day_numbers.length > 0) {
      $('.week_day_numbers:checked').each(function () {
        weekly_close_days.push($(this).val());
      })
    }

    if (jQuery.isEmptyObject(weekly_close_days)) {
      alert('定休日を設定してください');
      return
    }
    const data = {
      account_id: $('#account_id').val(),
      weekly_close_days: weekly_close_days
    }
    $.ajax({
      type: "post",
      url: '/save_weekly_data',
      data: JSON.stringify(data),
      contentType: 'application/json',
      dataType: "json",
      success: function (result) {
        if (result) {
          
        }
      }
    });
  })

})