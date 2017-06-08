<%--
  Created by IntelliJ IDEA.
  User: lx
  Date: 2017/6/8
  Time: 12:31
  To change this template use File | Settings | File Templates.
--%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>纳税人管理</title>

    <link href="static/css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="static/easyui/uimaker/easyui.css">
    <link rel="stylesheet" type="text/css" href="static/easyui/uimaker/icon.css">
    <link rel="stylesheet" href="static/css/taxpayer.css">
</head>
<body>
<div class="container">
    <table id="dg" style="width:100%;"  data-options="
                rownumbers:true,
                singleSelect:false,
                autoRowHeight:false,
                pagination:true,
                fitColumns:true,
                striped:true,
                checkOnSelect:false,
                selectOnCheck:false,
                toolbar:'#tb',
                pageSize:10">
        <thead>
        <tr>
            <th field="payerCode">纳税人识别号</th>
            <th field="payerName">纳税人名称</th>
            <th field="taxOrganId">所属税务机关</th>
            <th field="industryId">所属行业</th>
            <th field="legalResent">法人代表</th>
            <th field="legalResentCode">法人身份证号码</th>
            <th field="financeName">主管财务</th>
            <th field="financeCode">财务身份证号码</th>
            <th field="staffName">办税人员</th>
            <th field="createTime">录入日期</th>
            <th width="200" field="operation">操作</th>
        </tr>
        </thead>
    </table>
    <div id="tb" style="padding:0 30px;">
        纳税人识别号: <input class="easyui-textbox" type="text" name="payerCode" style="width:166px;height:35px;line-height:35px;"/>
        纳税人名称: <input class="easyui-textbox" type="text" name="payerName" style="width:166px;height:35px;line-height:35px;"/>
        <a href="javascript:void(0);" id="searchBtn" class="easyui-linkbutton" iconCls="icon-search" data-options="selected:true">查询</a>
        <a href="javascript:void(0);" id="setBtn" class="easyui-linkbutton" iconCls="icon-reload">重置</a>
        <a href="javascript:void(0);" id="addBtn" class="easyui-linkbutton" iconCls="icon-add">添加纳税人</a>
    </div>
</div>
<script type="text/javascript" src="static/jquery/jquery.min.js"></script>
<script type="text/javascript" src="static/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="static/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
    (function($){
        function pagerFilter(data){
            if ($.isArray(data)){   // is array
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var target = this;
            var dg = $(target);
            var state = dg.data('datagrid');
            var opts = dg.datagrid('options');
            if (!state.allRows){
                state.allRows = (data.rows);
            }
            if (!opts.remoteSort && opts.sortName){
                var names = opts.sortName.split(',');
                var orders = opts.sortOrder.split(',');
                state.allRows.sort(function(r1,r2){
                    var r = 0;
                    for(var i=0; i<names.length; i++){
                        var sn = names[i];
                        var so = orders[i];
                        var col = $(target).datagrid('getColumnOption', sn);
                        var sortFunc = col.sorter || function(a,b){
                                return a==b ? 0 : (a>b?1:-1);
                            };
                        r = sortFunc(r1[sn], r2[sn]) * (so=='asc'?1:-1);
                        if (r != 0){
                            return r;
                        }
                    }
                    return r;
                });
            }
            var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = state.allRows.slice(start, end);
            return data;
        }

        var loadDataMethod = $.fn.datagrid.methods.loadData;
        var deleteRowMethod = $.fn.datagrid.methods.deleteRow;
        $.extend($.fn.datagrid.methods, {
            clientPaging: function(jq){
                return jq.each(function(){
                    var dg = $(this);
                    var state = dg.data('datagrid');
                    var opts = state.options;
                    opts.loadFilter = pagerFilter;
                    var onBeforeLoad = opts.onBeforeLoad;
                    opts.onBeforeLoad = function(param){
                        state.allRows = null;
                        return onBeforeLoad.call(this, param);
                    }
                    var pager = dg.datagrid('getPager');
                    pager.pagination({
                        onSelectPage:function(pageNum, pageSize){
                            opts.pageNumber = pageNum;
                            opts.pageSize = pageSize;
                            pager.pagination('refresh',{
                                pageNumber:pageNum,
                                pageSize:pageSize
                            });
                            dg.datagrid('loadData',state.allRows);
                        }
                    });
                    $(this).datagrid('loadData', state.data);
                    if (opts.url){
                        $(this).datagrid('reload');
                    }
                });
            },
            loadData: function(jq, data){
                jq.each(function(){
                    $(this).data('datagrid').allRows = null;
                });
                return loadDataMethod.call($.fn.datagrid.methods, jq, data);
            },
            deleteRow: function(jq, index){
                return jq.each(function(){
                    var row = $(this).datagrid('getRows')[index];
                    deleteRowMethod.call($.fn.datagrid.methods, $(this), index);
                    var state = $(this).data('datagrid');
                    if (state.options.loadFilter == pagerFilter){
                        for(var i=0; i<state.allRows.length; i++){
                            if (state.allRows[i] == row){
                                state.allRows.splice(i,1);
                                break;
                            }
                        }
                        $(this).datagrid('loadData', state.allRows);
                    }
                });
            },
            getAllRows: function(jq){
                return jq.data('datagrid').allRows;
            }
        })
    })(jQuery);
    function getData(){
        var rows = [];
        for(var i=1; i<=80; i++){
            rows.push({
                payerCode: '106951123456',
                payerName: '北京智递科技有限公司',
                taxOrgan: '北京市朝阳区国税分局',
                industryName: '信息技术',
                legalResent: '张天明',
                legalResentCode:'412221199012029410',
                financeName: '张晓',
                financeCode:"110211198012109871",
                staffName:"侯亮平",
                createTime:"2011-12-20 08:09:10",
                operation:"<a href='javascript:void(0)' class='modifyBtn' data-payer='1'>修改</a> " +
                "<a href=''>删除</a>" +
                "<a href='javascript:void(0)' class='addTask' data-payer='1' >新增任务</a>"
            });
        }
        return rows;
    }

    $(function(){
        $('#dg').datagrid({data:getData()}).datagrid('clientPaging');
    });
</script>
<script type="text/javascript">
    //为搜索按钮添加事件处理函数
    //为重置按钮添加事件处理函数
    //为添加纳税人添加事件处理函数
    $(function(){
        $("#addBtn").on("click",function(e){
            openTopWindow({
                width : 750,
                height : 600,
                title : "新增纳税人",
                url : "manage/addTaxpayer.jsp"
            });
        });

        /**
         *打开在父窗口中打开window
         */
        function openTopWindow(options){
            options = !options ? {} :options;
            options.width = !options.width ? 500 : options.width;
            options.height = !options.height ? 400 : options.height;
            options.url = !options.url ? "404.html" : options.url;
            options.title = !options.title ? "" : options.title;

            parent.$("#topWindow").window({
                title : options.title,
                width: options.width,
                height: options.height,
                content : "<iframe scrolling='no' frameborder='0' border='0' height='100%' width='100%' src='"+options.url+"'></iframe>",
                modal:true,
                resizable:false,
                collapsible:false
            });
        }

    });
</script>
</body>
</html>
