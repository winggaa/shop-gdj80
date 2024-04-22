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

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<title></title>
</head>
<body>
<div class="row">
	<div class="col-4"></div>
	<div class= "mt-5 col-4 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
		<h1 style="text-align: center">PLANT</h1>
		<form action="/shop/emp/empLoginAction.jsp">
	
		<input class="form-control mt-5" type="text" placeholder="id" name="empId" value="admin">
	
		<input class="form-control mt-5" type="password" placeholder="password" name="empPw" value="1234">
		<div class="d-grid gap-2">
  			<button class="btn btn-success mt-5" type="submit">Sign in</button>
		</div>
		</form>
	</div>
	<div class="col"></div>
</div>
</body>
</html>
