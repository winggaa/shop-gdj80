<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<% if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
Class.forName("org.mariadb.jdbc.Driver");
ResultSet rs1 = null;
Connection conn = null;
PreparedStatement stmt1 = null; 
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
String sql1 = "select category from category";
stmt1 = conn.prepareStatement(sql1);
rs1 = stmt1.executeQuery();

// JDBC API 종속된 자료구조 모델 ResultSet -> 기본 API 자료구조(ArrayList)로 변경
ArrayList<String> categoryList = new ArrayList<String>();

//ResultSet -> ArrayList<HashMap<String, Object>>
while(rs1.next()){
	categoryList.add(rs1.getString("category"));
}
	
		

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
				for(String c : categoryList){
			%>
				<option value="<%=c%>"><%=c%></option>
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