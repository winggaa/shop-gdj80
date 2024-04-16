<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.DBHelper"%>
<%@page import="shop.dao.EmpDAO"%>
<%@page import="org.mariadb.jdbc.client.util.Parameter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<% 

	System.out.println("test");
	request.setCharacterEncoding("UTF-8"); 
	// String insertCategory = request.getParameter("insertCategory"); 아래에 같은 form 에 있어서 null값이 넘어옴 전송되면.
	// String deleteCategory = request.getParameter("deleteCategory");             == 
	// System.out.println(deleteCategory);
	
	//System.out.println(insertCategory);
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
	String category = request.getParameter("category");
	
%>
<%




Connection conn = DBHelper.getConnection();
ResultSet rs1 = null;
PreparedStatement stmt1 = null; 
String sql1 = "SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category ASC";
stmt1  = conn.prepareStatement(sql1);
rs1 = stmt1.executeQuery();
ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>() ;
int totalRow = 0;

while(rs1.next()){
	HashMap<String, Object> m = new HashMap<String, Object>();
	m.put("category", rs1.getString("category"));
	m.put("cnt",	  rs1.getInt("cnt"));
	totalRow = rs1.getInt("cnt");
	categoryList.add(m);
}

%>

<%

int rowPerPage = 30;
int currentPage=1;
//System.out.println(totalRow+"<<<<row");
int startRow = (currentPage-1)*rowPerPage;
int lastPage = totalRow / rowPerPage;
if(request.getParameter("currentPage") != null){
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
}

if(totalRow % rowPerPage !=0){
	lastPage = lastPage + 1;
}
%>
<%
/*
null이면
select * from goods
null이 아니면
select * from goods where category=?

*/
String searchWord = "";
if(request.getParameter("searchWord") !=null){
	searchWord = (request.getParameter("searchWord"));
}
	// 굿즈 리스트 불러오는 메소드 
ArrayList<HashMap<String,Object>> goodsList = GoodsDAO.goodsList(category, searchWord, startRow, rowPerPage);
	
%>


<% 
	// 카테고리 생성 메소드
	String insertCategory = request.getParameter("insertCategory");
	GoodsDAO.insertCategory(insertCategory);
%>

<%	
	// 카테고리 삭제 메소드 
	String deleteCategory = request.getParameter("deleteCategory");
	GoodsDAO.deleteCategory(deleteCategory);
%>

<%

	ArrayList<HashMap<String,Object>> allCategory = new ArrayList<HashMap<String,Object>>(); 
	ResultSet rs5 = null;
	PreparedStatement stmt5 = null;
	String sql5 = "select * FROM category";
	
	stmt5 = conn.prepareStatement(sql5);
	rs5 = stmt5.executeQuery();
		
	while(rs5.next()){
		//System.out.println(rs5.getString("category"));	
		HashMap<String,Object> ac = new HashMap<String,Object>();	
		ac.put("category", rs5.getString("category"));
		ac.put("createDate", rs5.getString("create_date")); 
		allCategory.add(ac);
		
	}
	for(HashMap abc : allCategory )  {
		System.out.println((String) (abc.get("category")));
	}
	
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
	<div class="row">
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<h1 style="text-align: center">캐러셀 상품 홍보 자리</h1>
	<div class="container" style="width:1500px;height: 300px;">
	<div id="carouselExampleSlidesOnly" class="carousel slide" data-bs-ride="carousel">
		  <div class="carousel-inner">
		   <div class="carousel-item active">
      		<img src="/shop/upload/img1.png" class="d-block w-100"  style="height: 300px;">
    	   </div>
    	   
		  <% 
		for(HashMap sm :goodsList){
		%>
		    <div class="carousel-item">
		      <img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>" class="d-block w-100 " style="width:1000px;height: 300px;	">
		   </div>
		  <%} %> 
		     
		  </div>
		</div>
	</div>
	
	<div>
		<a href="/shop/emp/addGoodsForm.jsp">상품등록</a>
	</div>
	<form action="/shop/emp/goodsList.jsp" >
		<div class="row" >
		<div class="col-2" style="background-color:#E8D9FF;">
		<h2>이벤트 팝업 자리 ?</h2>
		
		</div>
		<div class="col" style="background-color:#CEFBC9 ">
			<div>
				<a href="/shop/emp/goodsList.jsp">전체</a>
				<% 
					for(HashMap m :categoryList){
				%>
					<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
						<%=(String) (m.get("category"))%>
						(<%=(Integer) (m.get("cnt"))%>)
					</a>
					
				<%
					}
				%>
				
				
				<!-- Button trigger modal -->
					<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
					  카테고리 추가
					</button>
					
					<!-- Modal -->
					
					<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
					  <div class="modal-dialog">
					    <div class="modal-content">
					      <div class="modal-header">
					        <h1 class="modal-title fs-5" id="exampleModalLabel">카테고리 추가</h1>
					        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					      </div>
					      <div class="modal-body">
					        카테고리 이름을 입력해주세요
					        <input type="text" name="insertCategory" >
					      </div>
					      <div class="modal-footer">
					        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소하기</button>
					        <button type="submit" class="btn btn-primary">입력하기</button>
					      </div>
					    </div>
					  </div>
					</div>
					
					
					
					
				<!-- --------------------------------------------------- -->
				<!-- Button trigger modal -->
					<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#deleteModal">
					  카테고리 삭제
					</button>
					
					<!-- Modal -->
					
					<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
					  <div class="modal-dialog">
					    <div class="modal-content">
					      <div class="modal-header">
					        <h1 class="modal-title fs-5" id="exampleModalLabel2">카테고리 삭제</h1>
					        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					      </div>
					      <div class="modal-body">
					        <h2>주의:선택된 카테고리의 모든 데이터가 삭제됨</h2>
					        카테고리를 선택해주세요
					        <select name="deleteCategory">
							<option value="">선택</option>
							
							<%
								for(HashMap am : allCategory){
									
							%>
								<option value="<%=(String) (am.get("category"))%>"><%=(String) (am.get("category"))%></option>
							<%
								}
							%>
							</select>
					      </div>
					      <div class="modal-footer">
					        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">삭제취소</button>
					        <button type="submit" class="btn btn-primary">삭제하기</button>
					      </div>
					    </div>
					  </div>
					</div>
					</form>
					
					<form action="/shop/emp/goodsList.jsp">
					<input type="text" name="searchWord">
					 
					
					<%if(category != null){
						
						%>					
					
					<input type="hidden" name="category" value="<%=category%>">
					
					<%
					}
					%>
					
					</form>
					
				<!-- --------------------------------------------------- -->
				
				
			</div>
			
			
	
	
			<div class="d-flex flex-wrap">
		<% 
		for(HashMap sm :goodsList){
		%>
		
		<div class="p-2 flex-fill" style="text-align: center">
				<a href="/shop/emp/goodsListOne.jsp?goods_no=<%=(String) (sm.get("goodsNo"))%>">	
				<img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>"  style="width: 267px ; height: 200px " >
				</a>
				<br>	
				<sapn style="text-align: center"><%=(String) (sm.get("category"))%></sapn>
				<br>	
				<span style="text-align: center"><%=(String) (sm.get("goodsTitle"))%></span>
				<br>
				<sapn>가격:<%=(Integer) (sm.get("goodsPrice"))%></sapn>
				<br>
				<sapn>재고:<%=(Integer) (sm.get("goodsAmount"))%></sapn>
				
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
									<a href="/shop/emp/empList.jsp?currentPage=1" >처음페이지</a>
								</li>
								<li>
									<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
								</li>
						<%		
							} else {
						%>
								
								<li>
									<a style="pointer-events: none;" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
								</li>
						<%		
							}
						
							if(currentPage < lastPage) {
						%>
								<li>
									<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
								</li>
								<li>
									<a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
								</li>
						<%		
							}
						%>
					</ul>			
		
		
		

			</div>	
		</div>
	</div><!-- row	</div>  -->
</body>
</html>