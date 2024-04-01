<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	String loginEmp = (String) session.getAttribute("loginEmp");
	
	if("loginEmp" != null) {
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
	return;
}	else{
	String empId = null;
	String empPw = null;
	empId = request.getParameter("empId");
	empPw = request.getParameter("empPw");

	Class.forName("org.mariadb.jdbc.Driver");
	ResultSet rs1 = null;
	Connection conn = null;
	PreparedStatement stmt1 = null; 
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	String sql1 = "select emp_id empId from emp where actrive = 'on' and emp_id = ? and emp_pw = password(?)";
	/*
	select emp_id empId 
	from emp
	where active='ON' and emp_id =? and emp_pw = password(?) 
	*/
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1 , empId);
	stmt1.setString(2 , empPw);
	rs1 = stmt1.executeQuery();
	
	// 인증분기	 : 세션변수 이름 - loginEmp
	if(rs1.next()){
		System.out.println("로그인 성공");
	session.setAttribute("loginEmp", rs1.getString("empId")); // 		
		response.sendRedirect("/emp/empList.jsp");
	}
	
	
	
	


%>

<%
	
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
