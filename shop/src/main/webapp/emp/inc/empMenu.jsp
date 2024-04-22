<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%
	HashMap<String,Object> loginMember = (HashMap<String,Object>) (session.getAttribute("loginEmp"));
%>



<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<div>
<nav class="nav">
	<a class="nav-link active" aria-current="page" href ="/shop/emp/empList.jsp">사원관리</a>
	<!-- category CRUD -->
	<!--  <a class="nav-link active" aria-current="page" href="/shop/emp/categoryList.jsp">카테고리관리</a>-->
	
	<a class="nav-link active" aria-current="page" href ="/shop/emp/goodsList.jsp">상품관리</a>
	
		<!--  개인정보수정 -->
		<a class="nav-link active bg-text" href="/shop/emp/empOne.jsp">
			<%=(String) (loginMember.get("empName"))%>
		</a>
	
		<a class="nav-link active bg-text" href="/shop/emp/empLogout.jsp">로그아웃</a>
		<a class="nav-link active bg-text" href="/shop/emp/addGoodsForm.jsp">상품등록</a>
	</nav>
</div>