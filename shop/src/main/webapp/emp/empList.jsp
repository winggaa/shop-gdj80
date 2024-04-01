<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>

<%
	// 인증분기	 : 세션변수 이름 - loginEmp
	String loginEmp = (String) session.getAttribute("loginEmp");
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
	/*
	select emp_id empId, emp_name empName, emp_job empJob,  hire_date hireDate, active
	from emp
	order by active asc, hire_date desc
	*/
	
	Class.forName("org.mariadb.jdbc.Driver");
	ResultSet rs1 = null;
	Connection conn = null;
	PreparedStatement stmt1 = null; 
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	String sql1 = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate , active from emp order by active asc, hire_date desc";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1>사원 목록</h1>
	<a href="/shop/emp/empLogout.jsp">로그아웃</a>
	<% while(rs1.next()){
		%>
	
	
	<div><%=rs1.getString("empId")%></div>
	<%System.out.println(rs1.getString("empId")); %>
	<%=rs1.getString("empName")%>
	<%=rs1.getString("empJob")%>
	<%=rs1.getString("hireDate")%>
	<%=rs1.getString("active") %>

	<form action ="/emp/modifyEmpActive.jsp" >
	<input type="hidden" value="<%=rs1.getString("active") %>" name="active">
	<input type="text" value="<%=rs1.getString("empJob")%>" name="test" > 
	<button type="submit">제출</button>
		
	</form>
	
	<% 
}
	%>
	
</body>
</html>
