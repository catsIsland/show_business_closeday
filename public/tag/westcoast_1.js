$.when(
  close_days_script = document.createElement('script'),
  close_days_script.type = 'text/javascript',
  close_days_script.src = "http://localhost:3000/js/close_days.js?" + Date.now(),
  close_days_script.charset = 'UTF-8',
  document.getElementsByTagName('body')[0].appendChild(close_days_script),
  close_days_css = '<link rel="stylesheet" rel="nofollow" href="http://localhost:3000/css/close_days.css?' + Date.now() + '" type="text/css">',
  $('head').append(close_days_css)
).done(function () {
  $(document).ready(function () {
    url = "http://localhost:3000/close_days";
    let close_days_fun_count = 0;
    let close_days_interval = setInterval(function () {
      if (typeof show_close_days_calendar == 'function') {
        show_close_days_calendar(1, url);
        clearInterval(close_days_interval);
      }
      if (++close_days_fun_count > 1000) {
        clearInterval(close_days_interval);
      }
    }, 100);
  });
});