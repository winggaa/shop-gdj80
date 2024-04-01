<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 인증분기	 : 세션변수 이름 - loginEmp
	if(session.getAttribute("loginEmp") != null) {
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>

<%
	String empId = null;
	String empPw = null;
	
	/*
	select emp_id empId 
	from emp
	where active='ON' and emp_id =? and emp_pw = password(?) 
	*/
	
	/*
		실패 /emp/empLoginForm.jsp
		성공 /emp/empList.jsp
	*/
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

<form action="/shop/emp/empLoginAction.jsp">
id:
<input type="text" name="empId">
pw:
<input type="password" name="empPw">
<button type="submit">login</button>
</form>
</body>
</html>
