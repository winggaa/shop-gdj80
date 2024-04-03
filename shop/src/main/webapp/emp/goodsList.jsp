<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<% if(session.getAttribute("loginEmp") == null) {
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
System.out.println(totalRow+"<<<<row");
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
System.out.println(stmt2);
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
<!--  model layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<div>
		<a href="/shop/emp/addGoodsForm.jsp">상품등록</a>	
	</div>
		
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
	</div>
	<table border ="1">
	<% 
	for(HashMap sm :goodsList){
	%>
		<tr>
		<td><%=(String) (sm.get("category"))%>	</td>
		<td><%=(String) (sm.get("goodsTitle"))%></td>
		<td><%=(String) (sm.get("category"))%></td>
		<td><%=(Integer) (sm.get("goodsPrice"))%></td>
		</tr>
	<%
	}
	%> 
	</table>
	
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
				
	
</body>
</html>