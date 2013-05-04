###-----------------------------------------
# form.js 是利用 client-side-validation
# 和 twitter-bootstrap-rails 这两个gem来
# 实现表达元素的 info, success, error三种状态
#-------------------------------------------
###
jQuery ->

  ###------------------------------------
  # 自定义focus_blur, 模仿hover函数而成
  # _focus为处理获得焦点事件的函数
  # _blur为处理失去焦点事件的函数
  # -------------------------------------
  ###
  jQuery.fn.focus_blur = (_focus, _blur)->
    _self = $(this)
    _focus = arguments[0]
    _blur = arguments[1]

    _self.each ->  # 遍历选中的类数组中的所有元素,并给它们绑定事件
      _this = $(this)
      _data_info = _this.attr('data-info') || ''
      @_control_group = _this.parents('.control-group')
      @_controls = _this.parents('.controls')
      ###
      # 下面两行分别是表单元素获得和失去焦点是显示的文本
      ###
      @_help_inline_info = $("<span class='help-inline info'>"+ _data_info + "</span>")
      @_help_inline_success = $("<span class='help-inline success'>输入有效</span>")
      _this.focus(_focus)
      _this.blur(_blur)

  _data_validate = $('form *[data-validate=true]') # 标记有validate=true的form下的所有表单元素
  _data_validate.focus_blur(->
    hide_notice(@_control_group, 'error', 'label.message')
    hide_notice(@_control_group, 'success', 'span.help-inline.success')
    show_notice(@_control_group, @_controls, 'info',
    @_help_inline_info, 'span.help-inline.info')
  ,
  ->
    hide_notice(@_control_group, 'info', 'span.help-inline.info')
    unless @_control_group.find('label.message').text() == ''
      show_notice(@_control_group, @_controls, 'error', null, 'label.message')
    else
      show_notice(@_control_group, @_controls, 'success',
      @_help_inline_success, 'span.help-inline.success')
    )

  ###----------------------------------------------
  # client-side-validation 对password_confirmation
  # 验证没效，下面对它做专门验证
  #------------------------------------------------
  ###
  $('input[name*=password_confirmation]').focus_blur ->
    hide_notice($(this).parents('.control-group'), 'success', 'span.help-inline.success')
    hide_notice(@_control_group, 'error', 'label.error_message')
    show_notice(@_control_group, @_controls, 'info',
    @_help_inline_info, 'span.help-inline.info')
  ,
  ->
    hide_notice(@_control_group, 'info', 'span.help-inline.info')
    _self = $(this)
    _password = _self.parent().parent().parent().find('.password-field').first()
    if _self.val() == ''
      show_notice(@_control_group, @_controls, 'error',
      $("<label class='error_message'>不能为空</label>"), 'label.message')
    else if _self.val() != _password.val()
      show_notice(@_control_group, @_controls, 'error',
      $("<label class='error_message'>两次输入不匹配</label>"), 'label.message')
    else
      show_notice(@_control_group, @_controls, 'success',
       @_help_inline_success, 'span.help-inline.success')

  ###----------------------------------------------
  # 因为model中没有old_password这个属性, 无法用client
  # 验证没效，下面对它做专门验证
  #------------------------------------------------
  ###
  $('#old_password').focus_blur ->
    hide_notice($(this).parents('.control-group'), 'success', 'span.help-inline.success')
    hide_notice(@_control_group, 'error', 'label.error_message')
    show_notice(@_control_group, @_controls, 'info',
    @_help_inline_info, 'span.help-inline.info')
  ,
  ->
    hide_notice(@_control_group, 'info', 'span.help-inline.info')
    _self = $(this)
    hide_notice($(this).parents('.control-group'), 'success', 'span.help-inline.success')
    if _self.val() == ''
      show_notice(@_control_group, @_controls, 'error',
      $("<label class='error_message'>不能为空</label>"), 'label.message')
    else if _self.val()[5] == undefined
      show_notice(@_control_group, @_controls, 'error',
      $("<label class='error_message'>太短</label>"), 'label.message')
    else
      show_notice(@_control_group, @_controls, 'success',
       @_help_inline_success, 'span.help-inline.success')
  ###--------------------------------------
  # 下面对tokenInput这个jquery插件的表单效果
  # 做特殊处理
  #----------------------------------------
  ###
  token_focus_blur = ->

    ###----------------------------------------
    # jquery 1.7 开始就放弃 live()方法了, 下面是
    # 利用 欧尼()方法来达到 live()效果的写法
    #----------------------------------------
    ###
    $('form').on('focus', '#token-input-bill_goods_token_input', ->
      ###----------------------------------------
      # 下面这三行在两个函数中的重复, 几乎是无法去除的
      # 以为有些元素是动态创建的, 去重复后无法绑定事件
      #----------------------------------------
      ###
      _ul = $(this).parent().parent()
      _control_group = $(this).parents('.control-group')
      _controls = $(this).parents('.controls')

      hide_notice_token(_control_group, 'success', 'span.help-inline.success')
      hide_notice_token(_control_group, 'error', 'label.error_message')
      hide_notice_token(_control_group, 'info', 'span.help-inline.info')
      show_notice(_control_group, _controls, 'info',
      $("<span class='help-inline info token_help_inline'>请输入你账单中的商品</span>"),
        'span.help-inline.info')
      _ul.css('borderColor', '#2d6987') # 因为tokenInput的dom组成和其他表单不同, 特殊处理其边框颜色
    )

    $('form').on('blur', '#token-input-bill_goods_token_input', ->
      _ul = $(this).parent().parent()
      _control_group = $(this).parents('.control-group')
      _controls = $(this).parents('.controls')

      hide_notice_token(_control_group, 'info', 'span.help-inline.info')
      unless $('.token_formatter_li').text() == ''
        show_notice(_control_group, _controls, 'success',
        $("<span class='help-inline success token_help_inline'>输入有效</span>"),
        'span.help-inline.success')
        _ul.css('borderColor', '#468847')
      else
        show_notice(_control_group, _controls, 'error',
        $("<label class='error_message token_help_inline token_error_message'>不能为空</label>"),
        'label.message')
        _ul.css('borderColor', '#b94a48')
    )

  token_focus_blur.call() # 立即执行上面的函数完成绑定
  ###----------------------------------------
  # 显示提示消息,同时完成表单三种状态
  # info, success, error的转换
  #----------------------------------------
  ###
  show_notice = (_control_group, _controls, to_add, to_append, to_show)->
    _control_group.addClass(to_add)
    _controls.append(to_append)
    _control_group.find(to_show).show()

  ###----------------------------------------
  # 隐藏提示消息 同时完成三种状态的转换
  #----------------------------------------
  ###
  hide_notice = (_target, to_rm, to_hide)->
    _target.removeClass to_rm
    _target.find(to_hide).hide()

  ###----------------------------------------
  # 专门为token定制的hide notice
  # ----------------------------------------
  ###
  hide_notice_token = (_target, to_rm, to_hide)->
    _target.removeClass to_rm
    _target.find(to_hide).remove()
