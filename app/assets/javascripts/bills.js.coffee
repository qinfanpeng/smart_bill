jQuery ->
  ###----------------------------------------
  # 为防止和数据库中已有goods name的id重复,
  # 所有为新增的goods name设置一个比较大的
  # 起始值
  #----------------------------------------
  ###
  _new_name_id = 50000

  ###----------------------------------------
  # 简单封装tokenInput 方法,已完成自己不同输入
  # 的需求
  #----------------------------------------
  ###

  my_token_input = (_theme, _token_formatter, _prePopulate) ->

    $('#bill_goods_token_input').tokenInput('/goods_names',
      {
        theme: _theme,
        hintText: '请输入商品关键字',
        searchingText: '正在搜索...',
        noResultsText﻿: "无搜索结果",
        searchDelay: 300,
        tokenFormatter: (item) ->
          _token_formatter(item)
        onReady: =>
          ###
          if _theme == 'facebook'
            $('.token-input-list-facebook').append("<a id='add_new_goods'>第一次输入此商品? 点此添加</a>")
           else
            $('.token-input-list').append("<a id='add_new_goods' style='margin-top:-21px;'>第一次输入此商品? 点此添加</a>")
          @_add_a = $("#add_new_goods")
          @_add_a.hide()
          ###
          $("#token-input-bill_goods_token_input").keyup((e)->
            console.log e.which
            if e.which == 39
              #@_new_name = $(this).val()
              _new_name_id +=1
              $('#bill_goods_token_input').tokenInput('add', {id: '0', name: $(this).val() } )
            )
          #@_add_a.click =>
           # _new_name_id +=1
            # 新增的goods name都把id设为 0
            #$('#bill_goods_token_input').tokenInput('add', {id: '0', name: @_new_name } )
        ,
        onResult: (result)=>
          @result_len = result.length
          if result.length == 0
            #@_add_a.show()
            #@_new_name = $("#token-input-bill_goods_token_input").val()
            result
          else
            #@_add_a.hide()
            result
        ,
        onAdd: =>
          #@_add_a.hide()
        onDelete: =>
          ###---------------------------------
          # 当result length为 0时 表示此时删除的
          # token为新增的, 故把new_name_id 减一
          # ----------------------------------
          ###
          if @result_len == 0 then _new_name_id -= 1
        prePopulate: _prePopulate
      })

  data_prePopulate = $("#bill_goods_token_input").attr('data-prePopulate') || '{}'
  _prePopulate = $.parseJSON(data_prePopulate)
  ###-------------------------------------------
  # 商品简介录入模式: 只录入名字
  #-------------------------------------------
  ###
  $("#list_way_brief").click ->
    _new_name_id = 50000 # 重新初始化为50000
    ###-------------------------------------------
    # 接下来四行是为了切换输入模式时, 切换表单样式的
    # 使其正确地按info, success, error 切换
    #-------------------------------------------
    ###
    _list = $('.token-input-list')
    _list.parent().parent().removeClass('error info success')
    _list.parent().find('span.help-inline').remove()
    _list.parent().find('label.error_message').remove()

    _list.remove()
    $('.token-input-list-facebook').remove()
    my_token_input('facebook', brief_token_formatter, _prePopulate)
  ###-------------------------------------------
  # 商品详细录入模式: 录入名字, 数量, 金额等
  #-------------------------------------------
  ###
  $("#list_way_detail").click ->
    _new_name_id = 50000
    _list_facebook = $('.token-input-list-facebook')
    _list_facebook.parent().parent().removeClass('error info success')
    _list_facebook.parent().find('span.help-inline').remove()
    _list_facebook.parent().find('label.error_message').remove()
    _list_facebook.remove()
    $('.token-input-list').remove()
    my_token_input('', detail_token_formatter, _prePopulate)

  ###-------------------------------------------
  # 详细录入模式的token 格式, 包含名字, 数量, 金额等
  # 输入框, 以供用户录入
  #-------------------------------------------
  ###
  detail_token_formatter = (item)->
    _id = item.id
    ###-------------------------------------------
    # _id为0表示是新增的goods name, 此时要多加一个
    # type为hidden的new goods name字段
    # --------------------------------------------
    ###
    unless _id == "0"
      "<li class='token_formatter_li'>" +
      "<span class='goods'> #{item.name} </span>" +
      "<span class='goods'><label>单价:</label><input type='text' name='price_#{_id }' value='#{item.price || ''}'/></span>" +
      "<span class='goods'> x </span>"+
      "<span class='goods'><label>数量:</label><input type='text' name='amount_#{ _id }' value='#{item.amount || ''}'/></span>" +
      "<input type='hidden' name='good_information_id_#{_id}' value='#{item.good_information_id}'"+
      "</li>"
    else
      "<li class='token_formatter_li'>"+
      "<span class='goods'>"+ item.name +
      "</span><span class='goods'><label>单价:</label><input type='text' name='new_price_#{_new_name_id}'/></span>" +
      "<span class='goods'> x </span>"+
      "<span class='goods'><label>数量:</label><input type='text' name='new_amount_#{_new_name_id}'/></span>" +
      "<input type='hidden' name='new_name_#{_new_name_id}' value='#{item.name}' />"+
      "</li>"
  ###-------------------------------------------
  # 简介录入模式的 token 格式, 只包含名字
  # -------------------------------------------
  ###
  brief_token_formatter = (item)->
    _id = item.id
    unless _id == '0'
      "<li class='token_formatter_li'>#{item.name}"+
      "<input type='hidden' name='good_information_id_#{_id}' value='#{item.good_information_id}'</li>"
    else
      "<li class='token_formatter_li'>#{item.name}"+
      "<input type='hidden' name='new_name_#{_new_name_id}' value='#{item.name}' /></li>"

  ###-------------------------------------------
  # 默认为简单罗列所买物品
  # --------------------------------------------
  ###
  my_token_input('facebook', brief_token_formatter, _prePopulate)

  ###------------------------------------------
  # 监听账单组下拉列表选择改变
  #------------------------------------------
  ###
  $('#bill_group_id').change ->
    _value = $(this).val()
    unless  _value == ''  #不为个人账单组, 因此需准备支付者候选人
      $.get("/groups/#{_value}/members_select_of",
      (data)->
        _select = "<select id='bill_payer_id' name='bill[payer_id]' data-validate='true' data-info='请选择支付人'> "
        $(data).each ->
          _select += "<option value=#{this.id}>#{this.name}</option>"
        _select += "</select>"
        $("#bill_payer_id_controls").html(_select)
      )
