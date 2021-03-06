<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 2017/6/10
  Time: 16:28
  To change this template use File | Settings | File Templates.
--%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>办税专员</title>
    <link href="static/css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="static/easyui/uimaker/easyui.css">
    <link rel="stylesheet" type="text/css" href="static/easyui/uimaker/icon.css">
    <link rel="stylesheet" href="static/css/taxpayer.css">
</head>
<body>
<div class="container">
    <table id="dg" style="width:100%;"></table>
    <div id="tb" style="padding:0 30px;">
        办税人员名称: <input type="text" id="taxerName" name="taxerName" style="width:166px;height:35px;line-height:35px;"/>
        <a href="javascript:void(0);" id="searchBtn" class="easyui-linkbutton" iconCls="icon-search" data-options="selected:true">查询</a>
        <a href="javascript:void(0);" id="setBtn" class="easyui-linkbutton" iconCls="icon-reload">重置</a>
        <a href="javascript:void(0);" id="addBtn" class="easyui-linkbutton" iconCls="icon-add">添加办税专员</a>
    </div>

</div>
<script type="text/javascript" src="static/jquery/jquery.min.js"></script>
<script type="text/javascript" src="static/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="static/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="static/js/calendar.js"></script>
<script type="text/javascript">
    $("#dg").datagrid({
        url:'taxer/listTaxer.do',
        loadMsg:'数据加载中...',
        pagination:'true',
        toolbar: '#tb',
        columns:[[
            {field:'taxerCode',title:'税务人员工号',width:100},
            {field:'taxerName',title:'税务人员名称',width:100},
            {field:'mobile',title:'税务人员电话',width:100},
            {field:'address',title:'税务人员地址',width:100},
            {field:'sex',title:'性别',width:100},
            {field:'birthday',title:'出身日期',width:100},
            {field:'email',title:'邮箱',width:150},
            {field:'organId',title:'所属税务机关',width:100},
            {field:'option',title:'操作',width:100,
                formatter: function(value,row,index){
                    return "<a href='javascript:void(0)' onclick='info("+row.id+")'>查看</a>&nbsp;" +
                        "<a href='javascript:void(0)' onclick='edit("+row.id+")'>修改</a>&nbsp;" +
                        "<a href='javascript:void(0)' onclick='del("+row.id+")'>删除</a>";
                 }
            }
        ]]
    })

    //添加办税专员
    $("#addBtn").bind("click", function () {
        /*parent.$("#topWindow").window({
            title:'添加办税专员',
            width:800,
            height:600,
            content : "<iframe scrolling='no' frameborder='0' border='0' height='100%' width='100%' src='taxer/toAddTaxer.do'></iframe>",
            modal:true,
            resizable:false,
            collapsible:false
        });*/
        openWindow({"title":'添加办税专员', "url":"taxer/toAddTaxer.do", "width":"800", "height":"600"});
    })

    //点击查询
    $("#searchBtn").bind("click", function () {
        searchData();
    })

    //定义查询方法
    var searchData = function () {
        var taxerName =  $("#taxerName").val();
        $("#dg").datagrid("load", {
            "taxerName" : taxerName
        })
    }

    //重置
    $("#setBtn").bind("click", function () {
        $("#taxerName").val("");
    })

    //查看
    var info = function (id) {
        openWindow({"title":"办税人信息查看", "url":"taxer/taxerInfo.do?id="+id+"&state=info", "width":"800", "height":"600"})
    }

    //修改
    var edit = function (id) {
        openWindow({"title":"修改办税人信息", "url":"taxer/taxerInfo.do?id="+id+"&state=edit", "width":"800", "height": "600"})
    }
    //删除
    var del = function (id) {
        $.messager.confirm("提示信息", "确定删除?", function (r) {
            if (r) {
                $.post("taxer/deleteTaxer.do", {"id":id}, function (result) {
                    if (result.success) {
                        $.messager.alert('提示信息', result.msg,'info', function () {
                            $('#dg').datagrid('reload');
                        });
                    } else {
                        $.messager.alert('提示信息', result.msg, 'info')
                    }
                }, "json")
            }
        })
    }

    var openWindow = function (options) {
        options = !options ? {} : options;
        options.width = !options.width ? 500 : options.width;
        options.height = !options.height ? 400 : options.height;
        options.url = !options.url ? "404.html" : options.url;
        options.title = !options.title ? "" : options.title;

        parent.$("#topWindow").window({
            title:options.title,
            width:options.width,
            height:options.height,
            content : "<iframe scrolling='no' frameborder='0' border='0' height='100%' width='100%' src='"+options.url+"'></iframe>",
            modal:true,
            resizable:false,
            collapsible:false
        });
    }

    /**
     * 格式化时间
     * @param nS
     * @returns {string}
     */
    function getLocalTime(nS) {
        var date = new Date(nS.time);
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        var day = date.getDate();
        return year+"-"+month+"-"+day;
    }
</script>

</body>
</html>
