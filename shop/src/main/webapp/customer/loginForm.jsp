<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
 	if(session.getAttribute("loginCs")!=null){ //로그인이 이미 되어있다면
 		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
 		return;
 		}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>




<form method="post" action="/shop/customer/loginAction.jsp">
로그인아이디<input type="text" name="csId">
패스워드<input type="password" name="csPw">
<button type="submit">로그인</button>


<a href="/shop/customer/addCustomerForm.jsp">회원가입</a>
</form>
</body>
</html>