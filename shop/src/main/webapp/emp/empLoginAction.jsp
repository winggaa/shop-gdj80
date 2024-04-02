<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	
	
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}

	

	
	String empId = null;
	String empPw = null;
	empId = request.getParameter("empId");
	empPw = request.getParameter("empPw");
	System.out.println(empId);
	
	Class.forName("org.mariadb.jdbc.Driver");
	ResultSet rs1 = null;
	Connection conn = null;
	PreparedStatement stmt1 = null; 
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	String sql1 = "select emp_id empId from emp where active = 'on' and emp_id = ? and emp_pw = password(?)";
	/*
	select emp_id empId 
	from emp
	where active='ON' and emp_id =? and emp_pw = password(?) 
	*/
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1 , empId);
	stmt1.setString(2 , empPw);
	System.out.println(stmt1);
	rs1 = stmt1.executeQuery();

	// 인증분기	 : 세션변수 이름 - loginEmp
	if(rs1.next()){
		System.out.println("로그인 성공");
		session.setAttribute("loginEmp", rs1.getString("empId")); // 		
		response.sendRedirect("/shop/emp/empList.jsp");
	} else {		// 로그인실패
		System.out.println("로그인실패");
		String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");		
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감
	  }
	
	//자원반납
	rs1.close();
	stmt1.close();
	conn.close();

	
	


%>


