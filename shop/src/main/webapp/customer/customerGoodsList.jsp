<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>


<!--  /customer/goodsList.jsp-->
<!--  /customer/goodsOne.jsp + commentList-->
<!--  /customer/orderListByCustomer.jsp-->
<!--  결제완료(고객결제시) / 배송중(emp처리) / 배송완료(고객) --- 이되면 후기등록 버튼이 활성화.-->
<!--  insert into orders(mail,goods_no,price) values(`a@a.com`,1,5000)-->



<% 
	request.setCharacterEncoding("UTF-8"); 
	// String insertCategory = request.getParameter("insertCategory"); 아래에 같은 form 에 있어서 null값이 넘어옴 전송되면.
	// String deleteCategory = request.getParameter("deleteCategory");             == 
	// System.out.println(deleteCategory);
	
	//System.out.println(insertCategory);
	if(session.getAttribute("loginCs") == null) {
		response.sendRedirect("/shop/customer/loginForm.jsp");
		return;
	}

%>

<%
	String category = request.getParameter("category");
	
%>
<%
Class.forName("org.mariadb.jdbc.Driver");
ResultSet rs1 = null;
Connection conn = null;
PreparedStatement stmt1 = null; 
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
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
System.out.println(startRow);
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
	
	
ResultSet rs2 = null;
PreparedStatement stmt2 = null;
String sql2 = null;
//System.out.println(category);
	if(category == null){
	sql2 = "select * from goods where goods_title like ? limit ? , ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%"+searchWord+"%");
	stmt2.setInt(2, startRow);
	stmt2.setInt(3, rowPerPage);

	} else{
	sql2 = "select * from goods where category = ? and goods_title like ? limit ? , ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, category);
	stmt2.setString(2,"%"+searchWord+"%");
	stmt2.setInt(3, startRow);
	stmt2.setInt(4, rowPerPage);
	  }

//System.out.println(stmt2+"<<<<<<");
rs2 = stmt2.executeQuery();
//System.out.println(stmt2);
ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>() ;

while(rs2.next()){
	HashMap<String, Object> sm = new HashMap<String, Object>();
	sm.put("category", rs2.getString("category"));
	sm.put("empId",	  rs2.getString("emp_id"));
	sm.put("goodsTitle",rs2.getString("goods_title"));
	sm.put("goodsContent",rs2.getString("goods_content"));
	sm.put("goodsPrice",rs2.getInt("goods_price"));
	sm.put("goodsAmount",rs2.getInt("goods_amount"));
	sm.put("goodsImg",rs2.getString("filename"));
	sm.put("goodsNo",rs2.getString("goods_no"));
	goodsList.add(sm);
}
%>

<% 
	
	ResultSet rs3 = null;
	PreparedStatement stmt3 = null;
	String sql3 = null;
	sql3 = "insert into category(category) values(?)";
	//System.out.println(request.getParameter("insertCategory")+"<---insertcategory");
	if(request.getParameter("insertCategory") != null ){
	String insertCategory = request.getParameter("insertCategory");
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, insertCategory);
	//System.out.println(stmt3);
	rs3 = stmt3.executeQuery();
	response.sendRedirect("/shop/emp/goodsList.jsp");
	return;
	}
%>
<% 
	ResultSet rs4 = null;
	PreparedStatement stmt4 = null;
	String sql4 = null;
	sql4 = "DELETE FROM category WHERE category=?";
	//System.out.println(deleteCategory+ "<---deleteCategory");
	if(request.getParameter("deleteCategory") != null){
	String deleteCategory = request.getParameter("deleteCategory");
	stmt4 = conn.prepareStatement(sql4);
	stmt4.setString(1, deleteCategory);
	System.out.println(stmt4 +"<<<<<<<<stmt4");
	rs4 = stmt4.executeQuery();
	response.sendRedirect("/shop/emp/goodsList.jsp");
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