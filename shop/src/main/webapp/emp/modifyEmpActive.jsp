<%@page import="shop.dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%// 인증분기	 : 세션변수 이름 - loginEmp


	if(session.getAttribute("loginEmp") == null) {
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
	return;
}

	String active = request.getParameter("active");
//System.out.println(active+"액티브");
	String empId = request.getParameter("empId");
//System.out.println(empId+"<---empId");
	if(active.equals("ON")){
		active = "OFF";
	} else if(active.equals("OFF")){
		active = "ON";
	}

Connection conn = DBHelper.getConnection();
ResultSet rs1 = null;
PreparedStatement stmt1 = null; 

String sql1 = "UPDATE `shop`.`emp` SET active = ? WHERE emp_id=?";
stmt1 = conn.prepareStatement(sql1);
stmt1.setString(1,active);
stmt1.setString(2,empId );
rs1 = stmt1.executeQuery();

response.sendRedirect("/shop/emp/empList.jsp");

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