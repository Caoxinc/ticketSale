<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript">
        $(document).ready(function() { //页面加载执行
            $("#userInfo").click(function() {
                $.ajax({//校验权限
                    url : "http://localhost:8081/user/check",
                    type : "GET",
                    success : function(data) {
                        if (data.code == '0000') {
                            window.open("${pageContext.request.contextPath}/jsp/user/usermessage.jsp");
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert("出错了，请重试！");
                    }
                });
            });
        })
    </script>
</head>
<body>
<div id="page" class="clearfix">
    <div id="top">
        <a href="${pageContext.request.contextPath}/"> <img
                src="${pageContext.request.contextPath}/images/logo-main.jpg"
                style="width: 960px; height: 149px,"></a>
    </div>
    <div id="menu">
        <ul class="menubg">
            <li id="currentDate"><script language="JavaScript" src="${pageContext.request.contextPath}/js/date.js"
                                         type="text/javascript"></script></li>
            <li><a href="${pageContext.request.contextPath}/">首&nbsp;&nbsp;页</a></li>

            <li><a href="${pageContext.request.contextPath}/trainController/toSearchRout.action" target="_blank">立即购票</a></li>

            <li><a href="${pageContext.request.contextPath}/trainController/toSearchRout.action" target="_blank">余票查询</a></li>

            <li><a href="${pageContext.request.contextPath}/trainController/toSearchRout.action" target="_blank">路线查询</a></li>

            <li><a id="userInfo" href="javascript:void(0);">个人中心</a></li>

            <li><a href="${pageContext.request.contextPath}/orderController/orderListUi.action" target="_blank">订单中心</a></li>

            <li><a href="${pageContext.request.contextPath}/userController/toAdmin.action" target="_blank">后台管理</a></li>

            <li><a href="${pageContext.request.contextPath}/jsp/user/loginUi.jsp" target="_blank">用户登录</a></li>

            <li><a href="${pageContext.request.contextPath}/jsp/user/register.jsp" target="_blank">用户注册</a></li>

            <li><a href="${pageContext.request.contextPath}/jsp/admin/login.jsp" target="_blank">管理员登录</a></li>
        </ul>
    </div>
</div>
</body>
</html>