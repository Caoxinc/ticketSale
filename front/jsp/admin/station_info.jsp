<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="${pageContext.request.contextPath }/css/style2.css" rel="stylesheet" type="text/css"/>
    <style type="text/css">
        .toolbar li {
            background: url('${pageContext.request.contextPath }/images/toolbg.gif') repeat-x;
        }

        .tablelist th {
            background: url('${pageContext.request.contextPath }/images/th.gif') repeat-x;
        }

        .placeul li {
            background: url('${pageContext.request.contextPath }/images/rlist.gif') no-repeat right;
        }
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery2.js"></script>
    <script type="text/javascript">
        //获取当前url上的参数
        function getUrlPara() {
            var url = document.location.toString();
            var arrUrl = url.split("?");
            if (arrUrl.length == 1) return "";
            if (arrUrl[1].split("=").length == 1) return "";
            return arrUrl[1].split("=")[1];
        }

        var urlParam = getUrlPara();//页面url参数
        $(document).ready(function () { //页面加载执行
            $.ajax({ //加载车次编号下拉框
                url: "http://localhost:8084/train/listTid",
                type: "GET",
                success: function (data) {
                    if (data.code == '0000') {
                        var tidList = data.data;
                        for (var i = 0; i < tidList.length; i++) {
                            var trHTML = "<option value=" + tidList[i] + ">" + tidList[i] + "</option>";
                            $("#trainTid").append(trHTML);
                        }
                        if (urlParam != "") { //指定了车次编号
                            var trHTML = "<option selected='selected' value=" + urlParam + ">" + urlParam + "</option>";
                            $("#trainTid").append(trHTML);
                            //根据所选择的车次编号查询车站信息
                            getStationList();
                        }
                    } else {
                        alert(data.message);
                    }
                },
                error: function () {
                    alert("出错了，请重试！");
                }
            });
            //根据所选择的车次编号查询车站信息
            $('#trainTid').change(function () {
                getStationList();
            });
        })

        //根据所选择的车次编号查询车站信息
        function getStationList() {
            var tid = $("#trainTid").children('option:selected').val();
            var Tid = $("#trainTid").children('option:selected').text();
            if (urlParam != "") { //指定了车次编号
                tid = urlParam;
                Tid = urlParam;
            }
            if (tid == 0) {
                $("#tipmsg").text("请选择车次！");
                var tr = $("#tbodyid").ChildNode
                $("#tbodyid").remove(tr);
            } else {
                $("#tipmsg").text("");
                var tr = $("#tbodyid").ChildNode
                $("#tbodyid").remove(tr);
                $.ajax({
                    url: "http://localhost:8084/station/stationInfo",
                    type: "POST",
                    data: {"tid": Tid},
                    success: function (data) {
                        if (data.code == '0000') {
                            var stationList = data.data.stationList;
                            $("#stationTable").append("<tbody id='tbodyid'>");
                            for (var i = 0; i < stationList.length; i++) {
                                var sid = stationList[i].id;
                                var sname1 = stationList[i].name1;
                                var stime1 = stationList[i].time1;
                                var sname2 = stationList[i].name2;
                                var stime2 = stationList[i].time2;
                                var trHTML = "<tr><td><input type='text'  class='dfinput' id='name1_" + i + "' name='stationList[" + i + "].name1' value=" + sname1 + " disabled ='true'></td>"
                                    + "<td><input type='text' disabled ='true' class='dfinput' id='time1_" + i + "' name='stationList[" + i + "].time1' value=" + stime1 + "></td>"
                                    + "<td><input type='text' disabled ='true' class='dfinput' id='name2_" + i + "' name='stationList[" + i + "].name2' value=" + sname2 + "></td>"
                                    + "<td><input type='text' disabled ='true' class='dfinput' id='time2_" + i + "' name='stationList[" + i + "].time2' value=" + stime2 + "></td>"
                                    + "<td><a onclick=\"changehidden(\'name1_" + i + "\'" + ",\'time1_" + i + "\',\'name2_" + i + "\',\'time2_" + i + "\',\'sid_" + i + "\');\">修改</a>"
                                    + "<input type='hidden' disabled ='true' id='sid_" + i + "' name='stationList[" + i + "].id' value=" + sid + "></td></tr>";
                                $("#stationTable").append(trHTML);
                            }
                            $("#trainsale").append("</tbody>");
                        } else {
                            $("#tipmsg").text(data.message);
                        }
                    },
                    error: function () {
                        alert("出错了，请重试！");
                    }
                });
            }
        }

        //编辑框变为可修改
        function changehidden(id1, id2, id3, id4, id5) {
            var t1 = document.getElementById(id1);
            var t2 = document.getElementById(id2);
            var t3 = document.getElementById(id3);
            var t4 = document.getElementById(id4);
            var t5 = document.getElementById(id5);
            if (t1.disabled == false) {
                t1.disabled = true;
            } else {
                t1.disabled = false;
            }
            if (t2.disabled == false) {
                t2.disabled = true;
            } else {
                t2.disabled = false;
            }
            if (t3.disabled == false) {
                t3.disabled = true;
            } else {
                t3.disabled = false;
            }
            if (t4.disabled == false) {
                t4.disabled = true;
            } else {
                t4.disabled = false;
            }
            if (t5.disabled == false) {
                t5.disabled = true;
            } else {
                t5.disabled = false;
            }
        }

        function submitForm() { //修改车站信息提交
            if (checkForm()) {//校验表单
                $.ajax({
                    url: "http://localhost:8084/station/updateStation",
                    type: "POST",
                    data: $('#stationInfo').serialize(),
                    success: function (data) {
                        if (data.code == '0000') {
                            alert(data.message);
                            var tid = $("#trainTid").children('option:selected').val();
                            //刷新本信息页面
                            window.location.href = "../admin/station_info.jsp?tid=" + tid;
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("出错了，请重试！");
                    }
                });
            } else {
                return false;
            }
        }

        function checkForm() { //校验表单
            var table1 = document.getElementById("stationTable");
            var len = table1.rows.length - 1;//下标
            for (var i = 0; i < len; i++) {
                var sname1 = $("#name1_" + i).val();
                var stime1 = $("#time1_" + i).val();
                var sname2 = $("#name2_" + i).val();
                var stime2 = $("#time2_" + i).val();
                if (sname1 == "" || sname2 == "") {
                    alert("站点名称不能为空！");
                    return false;
                }
                if (stime1.length != 8 || stime2.length != 8) {
                    alert("时间输入不规范！请输入12:00:00格式");
                    return false;
                }
            }
            return true;
        }
    </script>
</head>

<body>
<div class="place"
     style="background:url('${pageContext.request.contextPath }/images/righttop.gif') repeat-x;">
    <span>位置：</span>
    <ul class="placeul">
        <li><a href="${pageContext.request.contextPath}/jsp/admin/index1.jsp"
               title="rightFrame">首页</a></li>
        <li><a href="">车站管理</a></li>
        <li><a href="">车辆站点/时间管理</a></li>
    </ul>
</div>

<form id="stationInfo">
    <div class="rightinfo">
        <div class="tools">
            <ul class="toolbar">
                <li style="border: none;"><span></span>车次:</li>
            </ul>
            <ul class="toolbar">
                <li><span></span>
                    <select class="toolbar" id="trainTid">
                        <option value="0">请选择车次</option>
                    </select></li>
            </ul>
            <ul class="toolbar">
                <li style="border: none;">
                    <span id="tipmsg" style="color: red">请选择车次！</span></li>
            </ul>
        </div>

        <table class="tablelist" id="stationTable">
            <thead>
            <tr>
                <th>从站点出发</th>
                <th>发车时间</th>
                <th>抵达下一站</th>
                <th>抵达时间</th>
                <th>操作</th>
            </tr>
            </thead>
        </table>
        <div><br/></div>
        <ul style="float:left;">
            <li><input type="button" value="提交" class="btn" onclick="submitForm();"></li>
        </ul>
        <div>&nbsp;</div>
        <ul style="float:left;">
            <li><span id="submitmsg" style="color: red">提示：仅提交可编辑的输入框内容！</span></li>
        </ul>
    </div>
</form>
</body>
</html>
