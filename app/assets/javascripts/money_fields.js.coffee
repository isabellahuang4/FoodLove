$ ->
  money_fields = $('input[data-role=money]')
  money_fields.autoNumeric('init');

  money_fields.keydown (event) ->
    if event.keyCode ==13
      $(this).autoNumeric('set', $(this).autoNumeric('get'))