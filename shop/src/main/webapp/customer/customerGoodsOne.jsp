<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.DBHelper"%>
<%@page import="org.apache.catalina.ha.backend.Sender"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>

<%  
	// goods_no값 받아오기
	int goodsNo = Integer.parseInt(request.getParameter("goods_no"));
	//System.out.println(goodsNo +"text no");
	//goods_no에 해당하는 db정보를 가져오는 메소드  
	ArrayList<HashMap<String,Object>> category = GoodsDAO.category(goodsNo);
	String img = (String)category.get(0).get("goodsImg");
	int goodsAmount = (int) category.get(0).get("goodsAmount");
	
	//System.out.println(category.get(0).get("goodsNo") + "어레이리스트에서 2차원배열 값빼오기");
	
	if(request.getParameter("purchase") != null){
		Connection conn = DBHelper.getConnection();
		String sql = "insert into orders(mail , goods_no , price , state) VALUES(? , ? , ? , '결제완료');";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setArray(1,);
		stmt.setArray(1,);
		stmt.setArray(1,);
		stmt.setArray(1,);
		
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<style>
	th{text-align: center}
	</style>
</head>
<body>
<!-- 메인메뉴 -->
	

	<div class="container" style="margin-top:150px; ">
		<table class="table border-top">

		<%
		for(HashMap<String,Object> sm : category){
		
		%>
			<tr>
				<th class="table-active">상품코드</th>
				<td style="width: 300px;"><%=goodsNo%></td>
				<th class="table-active">상품이름</th>
				<td><%=(String)(sm.get("goodsTitle"))%></td>
				<th class="table-active">상품카테고리</th>
				<td><%=(String)(sm.get("goodsCategory"))%></td>
				<th class="table-active">상품재고</th>
				<td><%=(int)(sm.get("goodsAmount"))%></td>
			</tr>
			
			<tr>
				<th class="table-active">상품이미지</th>
				<td style = "padding: 0px">
				<img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>"  style="width: 300px ; height: 300px; " >
				</td>			
				<th class="table-active">상품내용</th>
				<td colspan="5" style="width: 500px;" ><%=(String)(sm.get("goodsContent"))%></td>
			</tr>
			
			<tr>
				<th class="table-active">상품등록날짜</th>
				<td><%=(String)(sm.get("createDate"))%></td>
				<th class="table-active">상품수정날짜</th>
				<td colspan="5"><%=(String)(sm.get("updateDate"))%></td>
			</tr>

			<tr>
				<th class="table-active">상품가격</th>
				<td><%=(int)(sm.get("goodsPrice")) %></td> 
			</tr>
			
		<% 
		}
		%>
		</table>
	</div>
		<!-- goodsAmount의 수가 0이면 품절이므로 수량선택을 못하게막음. 단 null값이 들어갈수도 있으므로 구매하기 버튼도 막아야함. -->
	<div class="container" style="background-color:black;">
		<form action="/shop/customer/customerGoodsOne.jsp">
			<%if(goodsAmount < 1){ %>
			<select disabled>
			<%} else
			{
			%>
			<select>
				<%} %>
				<option value="1">1</option>
				
				<%	if(goodsAmount > 1){
					for(int i = 2 ; i <goodsAmount ; i++){	%>
				<option value="<%=i%>"><%=i%></option>
				
				<%	}
				  }	
				%>
			</select>
			<input type="hidden" value="purchase" name="purchase">
			<button type="submit">구매하기</button>
		</form>
	</div>
	<!--  리뷰페이지 고객이 상품을 구매후 배송와뇰가 뜨면 마이페이지에서 구매목록을 들어간후 리뷰작성하기가능.-->
	<div class="container mt-5" style="background-color:red;">
		<button>리뷰창</button>
		<div>제품명</div>
		<div>리뷰작성날짜</div>
		<div>사용자 아이디 or 이름 + 점수 value를 1~5로 받아서 별개수 찍기.</div>
		<div>리뷰내용</div>
	</div>

</body>
</html>