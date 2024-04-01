<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%// 인증분기	 : 세션변수 이름 - loginEmp
String loginEmp = (String) session.getAttribute("loginEmp");
if(session.getAttribute("loginEmp") == null) {
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
	return;
}

String active = request.getParameter("active");
System.out.println(active+"dasdasd");
String test = request.getParameter("test");
System.out.println(test+"asdasd");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

</body>
</html>