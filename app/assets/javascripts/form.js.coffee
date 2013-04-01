jQuery ->

  _data_validate = $('form *[data-validate=true]')

  jQuery.fn.focus_blur = (_focus, _blur)->
    _self = $(this)
    _focus = arguments[0]
    _blur = arguments[1]

    _self.each ->
      _this = $(this)
      _data_info = _this.attr('data-info') || ''
      @_control_group = _this.parents('.control-group')
      @_controls = _this.parents('.controls')

      @_help_inline_info = $("<span class='help-inline info'>"+ _data_info + "</span>")
      @_help_inline_success = $("<span class='help-inline success'>输入有效</span>")
      _this.focus(_focus)
      _this.blur(_blur)


  _data_validate.focus_blur(->
    hide_notice(@_control_group, 'error', 'label.message')
    hide_notice(@_control_group, 'success', 'span.help-inline.success')
    show_notice(@_control_group, @_controls, 'info', @_help_inline_info, 'span.help-inline.info')
  ,
  ->
    hide_notice(@_control_group, 'info', 'span.help-inline.info')
    unless @_control_group.find('label.message').text() == ''
      show_notice(@_control_group, @_controls, 'error', null, 'label.message')
    else
      show_notice(@_control_group, @_controls, 'success', @_help_inline_success, 'span.help-inline.success')
  )

  show_notice = (_control_group, _controls, to_add, to_append, to_show)->
    _control_group.addClass(to_add)
    _controls.append(to_append)
    _control_group.find(to_show).show()


  hide_notice = (_target, to_rm, to_hide)->
    _target.removeClass to_rm
    _target.find(to_hide).hide()