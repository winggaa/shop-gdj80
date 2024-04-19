<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.EmpDAO"%>
<%@page import="shop.dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<% if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}

// 카테고리 리스트를 불러오는 메소드 
ArrayList<HashMap<String,Object>> categoryList = GoodsDAO.allCategory();

%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</head>
<body>
<div>
</div>
	<!-- 메인메뉴 -->
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<h1>상품등록</h1>
	<form method="post" action="/shop/emp/addGoodsAction.jsp" enctype="multipart/form-data">


	<div>
		category:
		
		<select name="category" >
			<option value="">선택</option>
			<%
				for(HashMap<String, Object> c : categoryList){
			%>
				<option value="<%=c.get("category")%>"><%=c.get("category")%></option>
			<%
				}
			%>
		</select>
	</div>
	<!--  emp_id 값은 세션변수에서 바인딩 -->
	<div>
		goodsTitle:
		<input type="text" name ="goodsTitle" >
	</div>
	<div>
		goodsImage : 
		<input type="file" name="goodsImg">
	</div>
	
	<div>
		goodsPrice:
		<input type="number" name ="goodsPrice">
	</div>
	<div>
		goodsAmount:
		<input type="number" name ="goodsAmount">
	</div>
	<div>
		goodsContnet
		<textarea rows="5" cols="50" name="goodsContent"></textarea>
	</div>
	<div>
		<button type="submit">제출</button>
	</div>
	</form>
</body>
</html>