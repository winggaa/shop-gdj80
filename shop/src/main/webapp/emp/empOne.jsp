<%@page import="shop.dao.EmpDAO"%>
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
		//System.out.println(loginId);
		
		// empOne 목록 불러오는 메소드
	ArrayList<HashMap<String,Object>> list = EmpDAO.empOneList(loginId);
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
<% for(HashMap m : list){%>

<tr>
<th class="table-active" style="width: 100px">Id</th>
<td style="width: 300px;"><%=m.get("empId")%></td>
<th class="table-active" style="width: 100px">이름</th>
<td style="width: 300px;"><%=m.get("empName")%></td>
</tr>

<tr>

<th class="table-active">부서</th>
<td><%=m.get("empJob")%></td>
<th class="table-active">입사일</th>
<td><%=m.get("hireDate")%></td>
</tr>

<tr>
<th class="table-active">
가입날짜
</th>
<td ><%=m.get("createDate")%></td>
<th class="table-active">
마지막 수정날짜
</th>
<td >
<%=m.get("updateDate")%>
</td>
</tr>
<%} %>
</table>


<form action="/shop/emp/goodsList.jsp" >
		
			
			
																							<!-- data-bs-target: id가 deleteId인 요소지정 -->
			
</div>	


</body>
</html>