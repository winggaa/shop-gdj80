<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.DBHelper"%>
<%@page import="shop.dao.EmpDAO"%>
<%@page import="org.mariadb.jdbc.client.util.Parameter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<% 
	
	// 카테고리값 요청 -- null이면 전체 출력 값이 있으면 해당하는 카테고리 출력
	String category = request.getParameter("category");
	
	
	//카테고리 인덱스 메소드
	ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.categoryIndex();
	//출력할 데이터베이스의 총행 구하는 메소드
	int totalRow = 0;
	totalRow= GoodsDAO.totalRow(category);
	//페이징용 함수 선언
	int rowPerPage  = 30;
	int currentPage = 1;
	// currentPage가 다음페이지를 눌러서 +이되면 값을 받아오고 startRow값을 곱해야함
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int startRow = (currentPage-1)*rowPerPage;
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage !=0){
		lastPage = lastPage + 1;
	}
	/*	null이면 		select * from goods
		null이 아니면  select * from goods where category=?
		검색 값 분기	*/
	String searchWord = "";
	if(request.getParameter("searchWord") !=null){
		searchWord = (request.getParameter("searchWord"));
	}
	// 굿즈 리스트 불러오는 메소드  
	ArrayList<HashMap<String,Object>> goodsList = GoodsDAO.goodsList(category, searchWord, startRow, rowPerPage);
	// 삭제할 카테고리 목록 불러오기 
	ArrayList<HashMap<String,Object>> allCategory = GoodsDAO.allCategory();
%>

<!--  model layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<style>
	
	</style>
</head>
<body>
	<!-- 내비바 불러오기  -->
	
	
	<!-- 상품이미지 출력용.  -->
	<div class="container" style="width:1500px;height: 300px;">
		<div id="carouselExampleSlidesOnly" class="carousel slide mb-5" data-bs-ride="carousel">
		  <div class="carousel-inner">
		   <div class="carousel-item active">
      		<img src="/shop/upload/default.jpg" class="d-block w-100"  style="height: 300px;">
    	   </div>
    	   
<% 
		for(HashMap<String,Object> sm :goodsList){
%>
		   <div class="carousel-item ">
		      <img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>" class="d-block w-100 " style="width:1000px;height: 300px;">
		   </div>
<%
} 
%> 
		  </div>
		</div>
	</div>
	
	
	
		<div class="row mt-5">
			<div class="col-2" style="background-color:#E8D9FF;">
				
						<!-- category == null 이 아니면 카테고리별로 보기를 선택한것이므로 where 조건에 카테고리를 넣어 
							 해당하는 카테고리만 검색하기위해 category값 받는것.
						 -->		
				<form action="/shop/customer/customerGoodsList.jsp">
					<input type="text" name="searchWord">								 						
					<%if(category != null){
							
					%>					
						<input type="hidden" name="category" value="<%=category%>">
					<%
					}
					%>
				</form>
				
				<ul class="nav flex-column">
					<li class="nav-item">
						<a class="nav-link active" href="/shop/customer/customerGoodsList.jsp">전체보기</a>
					</li>
					<% for(HashMap<String,Object> m : categoryList)
					{
					%>
				  	<li class="nav-item">
				  		<a class ="nav-link active" href="/shop/customer/customerGoodsList.jsp?category=<%=(String)(m.get("category"))%>">
						<%=(String) (m.get("category"))%>
						(<%=(Integer) (m.get("cnt"))%>)
						</a>
				  	</li>
					<%
				 	}			  
					%>
				</ul>
			</div>
			<!--  goodsList 출력부분-->
			<div class="col" style="background-color:#CEFBC9 ">
				<div class="d-flex flex-wrap">
				<% 
				for(HashMap<String,Object> sm :goodsList)
				{
				%>
					<div class="p-2 flex-fill" style="text-align: center">
			
						<a href="/shop/customer/customerGoodsOne.jsp?goods_no=<%=(String) (sm.get("goodsNo"))%>">	
							<img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>" style="width: 267px ; height: 200px " >
						</a>
						<br>	
						<span style="text-align: center"><%=(String) (sm.get("category"))%></span>
						<br>	
						<span style="text-align: center"><%=(String) (sm.get("goodsTitle"))%></span>
						<br>
						<span>가격:<%=(Integer) (sm.get("goodsPrice"))%></span>
						<br>
						<span>재고:<%=(Integer) (sm.get("goodsAmount"))%></span>
				  	</div>			
				<%
				}
				%> 
				</div>
		
			<!-- 페이징 코드 -->
			<ul class="pagination justify-content-center">
	  			
			<%
				if(currentPage > 1) {
			%>
					<li>
						<a href="/shop/customer/customerGoodsList.jsp?currentPage=1&category=<%=category%>">처음페이지</a>
					</li>
					<li>
						<a href="/shop/customer/customerGoodsList.jsp?currentPage=<%=currentPage-1%>&category=<%=category%>">이전페이지</a>
					</li>
			<%		
				} else {
			%>	
					<li>
						<a style="pointer-events: none;" href="/shop/customer/customerGoodsList.jsp?currentPage=<%=currentPage-1%>&category=<%=category%>">이전페이지</a>
					</li>
			<%		
				}	
				if(currentPage < lastPage) {
			%>
					<li>
						<a href="/shop/customer/customerGoodsList.jsp?currentPage=<%=currentPage+1%>&category=<%=category%>">다음페이지</a>
					</li>
					<li>
						<a href="/shop/customer/customerGoodsList.jsp?currentPage=<%=lastPage%>&category=<%=category%>">마지막페이지</a>
					</li>
			<%		
				}
			%>
			</ul>			
			
			
			
	
			</div>	
		</div>
	<!-- row	</div>  -->
</body>
</html>