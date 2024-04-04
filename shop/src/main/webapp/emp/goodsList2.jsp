<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<% 
	request.setCharacterEncoding("UTF-8"); 
	String insertCategory = request.getParameter("insertCategory");
	String deleteCategory = request.getParameter("deleteCategory");
	System.out.println(deleteCategory);
	
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
int rowPerPage = 10;
int currentPage=1;
//System.out.println(totalRow+"<<<<row");
int startRow = (currentPage-1)*rowPerPage;
int lastPage = totalRow / rowPerPage;
if(request.getParameter("currentPage") != null){
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
}

if(totalRow%rowPerPage !=0){
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
ResultSet rs2 = null;
PreparedStatement stmt2 = null;
String sql2 = null;
System.out.println(category);
	if(category == null){
	sql2 = "select * from goods limit ? , ?";
	stmt2 = conn.prepareStatement(sql2);	
	stmt2.setInt(1, startRow);
	stmt2.setInt(2, rowPerPage);

	} else{
	sql2 = "select * from goods where category = ? limit ? , ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, category);
	stmt2.setInt(2, startRow);
	stmt2.setInt(3, rowPerPage);
	  }

System.out.println(stmt2+"<<<<<<");
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
	goodsList.add(sm);
}
%>

<% 
	ResultSet rs3 = null;
	PreparedStatement stmt3 = null;
	String sql3 = null;
	sql3 = "insert into category(category) values(?)";
	if(insertCategory != null){
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, insertCategory);
	//System.out.println(stmt3);
	rs3 = stmt3.executeQuery();
	response.sendRedirect("/shop/emp/goodsList.jsp");
	}
%>
<% 
	ResultSet rs4 = null;
	PreparedStatement stmt4 = null;
	String sql4 = null;
	sql4 = "DELETE FROM category WHERE category=?;";
	if(deleteCategory != null){
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
</head>
<body>
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<div>
		<a href="/shop/emp/addGoodsForm.jsp">상품등록</a>
	</div>
	
		<div class="row" >
		<div class="col-2" style="background-color:#E8D9FF;">사이드바 자리 회원정보 같은거</div>
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
					<form action="/shop/emp/goodsList.jsp" >
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
					        카테고리를 선택해주세요
					        <select name="deleteCategory">
							<option value="">선택</option>
							
							<%
								for(HashMap m : categoryList){
							%>
								<option value="<%=(String) (m.get("category"))%>"><%=(String) (m.get("category"))%></option>
							<%
								}
							%>
							</select>
					      </div>
					      <div class="modal-footer">
					        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소하기</button>
					        <button type="submit" class="btn btn-primary">입력하기</button>
					      </div>
					    </div>
					  </div>
					</div>
					</form>
				<!-- --------------------------------------------------- -->
	
				
				<a href="/shop/emp/addGoodsForm.jsp">카테고리 추가</a>		
			</div>
	
			<div class="d-flex flex-wrap">
		<% 
		for(HashMap sm :goodsList){
		%>
			
		<div class="p-2 flex-fill align-items-start">
				<img src="/shop/img/img1.png"  style="width: 267px ;, height: 183px" >
				<br>	
				<sapn style="text-align: center"><%=(String) (sm.get("category"))%></sapn>
				<br>	
				<span style="text-align: center"><%=(String) (sm.get("goodsTitle"))%></span>
				<br>
				<%=(String) (sm.get("category"))%>
				<br>
				<%=(Integer) (sm.get("goodsPrice"))%>
				
			</div>
		<%
		}
		%> 
		
		</div>
	
	
	
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