<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="shop.dao.DBHelper"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<%     
    HashMap<String,Object> loginMember = (HashMap<String,Object>) (session.getAttribute("loginEmp"));
	String loginId =(String)(loginMember.get("empId"));
	System.out.println(loginId);
	Connection conn = DBHelper.getConnection();
	
	String sql = "SELECT emp_id , emp_name , emp_job , hire_date , create_date, update_date FROM emp WHERE emp_id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,loginId);
	System.out.println(stmt);
	ResultSet rs = stmt.executeQuery();
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<style>
	th{text-align: center}
	</style>
</head>
<body>
<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
<div class="container" style="margin-top:150px; ">
<h1>직원정보</h1>
<table class="table border-top">
<% while(rs.next()) {%>

<tr>
<th class="table-active">Id</th>
<td style="width: 300px;"><%=rs.getString("emp_id") %></td>
<th class="table-active">이름</th>
<td><%=rs.getString("emp_name")%></td>
</tr>

<tr>

<th class="table-active">부서</th>
<td><%=rs.getString("emp_job")%></td>
<th class="table-active">고용일</th>
<td><%=rs.getString("hire_date")%></td>
</tr>

<tr>
<th class="table-active">
가입날짜
</th>
<td ><%=rs.getString("create_date")%></td>
<th class="table-active">
마지막 수정날짜
</th>
<td >
<%=rs.getString("update_date")%>
</td>
</tr>
<%} %>
</table>
</div>

</body>
</html>