<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link type="text/css"
          href="${pageContext.request.contextPath }/css/css.css" rel="stylesheet" />
    <link rel="shortcut icon" type="image/x-icon"
          href="${pageContext.request.contextPath}/images/favicon.ico" />
    <link rel="icon" type="image/x-icon"
          href="${pageContext.request.contextPath}/images/favicon.ico" />
    <script type="text/javascript"
            src="${pageContext.request.contextPath }/js/jquery.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath }/js/js.js"></script>
    <link href="${pageContext.request.contextPath }/css/headerlog.css" rel="stylesheet">
    <style type="text/css">
        .nav1 li a {
            display: block;
            height: 28px;
            line-height: 28px;
            color: #fff;
            font-size: 14px;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function() {
            var msg = "${resmsg}";
            if(msg != ""){
                alert(msg);
            }
            var uid = "${sessionScope.loginUser.uid}";
            $.ajax({
                url : "${pageContext.request.contextPath }/userController/findPassenger.action",
                type : "POST",
                data : {"uid" : uid},
                success : function(returnData) {
                    if (returnData == null) {// 没查询到结果
                        $("#tipmsg").text("未查询到结果！");
                    } else {
                        $("#showpassenger").append("<tbody id='tbodyid'>");
                        for (var i = 0; i <returnData.length; i++) {
                            var truename = returnData[i].trueName;
                            var passid =returnData[i].idCard;
                            var role = returnData[i].role;
                            var pid = returnData[i].pid;
                            var role1 =null;
                            if(role==1){/* 当数据库中乘客类型为1时，默认乘客类型为学生，否则默认为成人   */
                                var trHTML = "<tr id="+passid+"><td>"+truename
                                    +"</td><td>"+returnData[i].idCard
                                    +"</td><td>"+"<select name='role1' id="+pid+"><option value='0' >成人</option><option value='1' selected>学生</option></select>"
                                    +"</td><td><span class='green upd'  onclick='delete1(\""+passid
                                    +"\""+",\""+pid+"\""+");'>[删除]</span>|<span onclick='updateType(\""+pid
                                    +"\""+");'  class='green upd'>[修改]</span></td>"
                                    +"</tr>" ;
                                $("#showpassenger").append(trHTML);
                            }else{
                                var trHTML = "<tr id="+passid+"><td>"+truename
                                    +"</td><td>"+returnData[i].idCard
                                    +"</td><td>"+"<select name='role1' id="+pid+"><option value='0' selected>成人</option><option value='1'>学生</option></select>"
                                    +"</td><td><span class='green upd'  onclick='delete1(\""+passid
                                    +"\""+",\""+pid+"\""+");'>[删除]</span>|<span onclick='updateType(\""+pid
                                    +"\""+");' class='green upd'>[修改]</span>  </td>"
                                    +"</tr>" ;
                                $("#showpassenger").append(trHTML);
                            }
                        }
                        $("#showpassenger").append("</tbody>");
                    }
                }
            });
        })

        /*修改乘客类型   */
        function updateType(pid){
            var role =document.getElementById(pid).value;
            $.ajax({
                url : "${pageContext.request.contextPath }/userController/updateType.action",
                type : "POST",
                data : {"pid":pid,"role":role},
                success : function(returnData) {
                    if (returnData != null) {
                        alert(returnData.msg);
                    }
                }
            });
        }

        function f1(){ //姓名校验
            var cardlen = $("#realName").val();
            if(cardlen == ""){
                $("#name1").html("请输入乘客姓名！");
                $("#realName").focus();
            } else {
                $("#card1").html("");
            }
        }

        function a(){ //身份证校验
            var cardlen = $("#cardNumber").val().length;
            if(cardlen!= 18){
                $("#card1").html("身份证号码必须为18位");
                $("#cardNumber").focus();
            } else {
                $("#card1").html("");
            }

        }

        function delete1(ptr, pid){ //删除
            var chr =  document.getElementById(ptr);
            var uid = "${sessionScope.loginUser.uid}";
            $.ajax({
                url : "${pageContext.request.contextPath }/userController/deletepassenger.action",
                type : "POST",
                data : {"uid" : uid,"pid":pid},
                success : function(returnData) {
                    if (returnData != null) {
                        alert(returnData.msg);
                    }
                }
            });
            chr.remove(ptr);
        }

        function sub(){ //提交检验
            var realName = $("#realName").val();
            var cardNumber = $("#cardNumber").val();
            if(realName == "" || cardNumber == ""){
                alert("请先输入乘客信息！");
                $("#realName").focus();
                return false;
            } else {
                return true;
            }
        }
    </script>
</head>

<body>
<!--header start-->
<%@ include file="header.jsp" %>
<!--header end-->
<div class="mianCont">
    <div class="top">
        <span class="topRight"></span>
    </div><!--top/-->
    <div class="pnt">
        <div class="clears"></div>
    </div><!--pnt/-->

    <div class="positions">
        当前位置：<a href="${pageContext.request.contextPath}/">首页</a> &gt;
        <a href="${pageContext.request.contextPath}/jsp/user/usermessage.jsp">用户中心</a> &gt;
        <a href="${pageContext.request.contextPath}/jsp/user/passenger.jsp">乘客信息</a>
    </div>
    <!--positions/-->
    <div class="cont">
        <div class="contLeft" id="contLeft">
            <h3 class="leftTitle">用户中心</h3>
            <dl class="helpNav vipNav">
                <dt>账户设置</dt>
                <dd>
                    <a href="${pageContext.request.contextPath}/userController/tousermessage.action">个人信息</a>
                    <a href="${pageContext.request.contextPath}/userController/topassword.action">密码修改</a>
                </dd>
                <dt>信息管理</dt>
                <dd>
                    <a href="${pageContext.request.contextPath}/orderController/orderListUi.action">我的订单</a>
                    <a href="${pageContext.request.contextPath}/jsp/user/passenger.jsp">乘客信息</a>
                </dd>
                <dt>客户服务</dt>
                <dd>
                    <a href="">网站使用条款</a>
                    <a href="">网站免责声明</a>
                    <a href="">在线留言</a>
                </dd>
            </dl><!--helpNav/-->
        </div><!--contLeft/-->
        <div class="contRight">
            <form action="${pageContext.request.contextPath}/userController/addpassenger.action" method="post" name="passenger">
                <h2 class="oredrName">乘客信息表<span class="green add">[添加乘客]</span></h2>
                <div class="address">
                    <div class="addList">
                        <label><span class="red">* </span>乘客真实姓名:</label>
                        <input type="text" id="realName" onblur="f1();" name="trueName"/>
                        <span id="name1" style="color: red; text-align: left;"></span>
                    </div><!--addList-->
                    <div class="addList">
                        <label><span class="red">* </span>身份证号码:</label>
                        <input type="text"  id="cardNumber" onblur="a();" name="idCard"/>
                        <span id="card1" style="color:red; text-align:left;"></span>
                    </div><!--addList-->
                    <div class="addList">
                        <label><span class="red">* </span>乘客类型:</label>
                        <select name="role" id="passengertype">
                            <option value="0">成人</option>
                            <option value="1">学生</option>
                        </select>
                    </div><!--addList-->
                    <div class="addList2">
                        <input type="hidden" value="${sessionScope.loginUser.uid}" name="uid">
                        <input type="submit" value="保存" onclick="return sub();" width="79" height="30">
                    </div><!--addList2/-->
                </div><!--address/-->
            </form>
            <table class="vipAdress" id="showpassenger">
                <thead>
                <tr >
                    <th>乘客真实姓名</th>
                    <th>身份证号</th>
                    <th>乘客类型</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table><!--vipAdress/-->

        </div>
        <!--contRight/-->
        <div class="clears"></div>
    </div><!--cont/-->

    <!--footer -->
    <%@ include file="footer.jsp" %>
    <!--footer/ -->
</div><!--mianCont/-->
<a href="#" class="backTop">&nbsp;</a>
</body>
</html>