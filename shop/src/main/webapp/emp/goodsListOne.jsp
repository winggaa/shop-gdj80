<%@page import="org.apache.catalina.ha.backend.Sender"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<% // 로그인 인증분기
 if(session.getAttribute("loginEmp") == null) {
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
	return;
}
%>

<% // goods_no값 받아오기
String goodsNo = request.getParameter("goods_no");
//System.out.println(goodsNo +"text no");
%>

<% // 데이터베이스 값 받아서 hashMap에 넣기
Class.forName("org.mariadb.jdbc.Driver");
ResultSet rs1 = null;
Connection conn = null;
PreparedStatement stmt1 = null; 
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
String sql1 = "select * from goods where goods_no = ?";
stmt1 = conn.prepareStatement(sql1);
stmt1.setString(1,goodsNo);
rs1 = stmt1.executeQuery();

	ArrayList<HashMap<String,Object>> category = new ArrayList<HashMap<String,Object>>() ;
	
	while(rs1.next()){
	HashMap<String,Object> s = new HashMap<String,Object>();
	s.put("goodsContent",rs1.getString("goods_content"));
	s.put("goodsPrice",rs1.getString("goods_price"));
	s.put("goodsImg",rs1.getString("filename"));
	s.put("goodsAmount",rs1.getString("goods_amount"));
	s.put("goodsCategory",rs1.getString("category"));
	s.put("goodsTitle",rs1.getString("goods_title"));
	s.put("createDate",rs1.getString("create_date"));
	s.put("updateDate",rs1.getString("update_date"));
	s.put("goodsNo",rs1.getInt("goods_no"));
	category.add(s);
	}
	
	System.out.println(category.get(0).get("goodsNo") + "어레이리스트에서 2차원배열 값빼오기");
	Object smm = category.get(0).get("goodsNo");
	
%>
		<%// System.out.println(category.get(0).get("goodsNo").toString()+"testtest");%>

<%

// File df = new File(filePath, rs.getString("filename"));
///<------------------------ 삭제 쿼리문 --------------------------------------------------------->


//String num = category.get(0).get("goodsNo").toString();
String deleteButton = request.getParameter("deleteButton");
//System.out.println(category.get(0,));
if(deleteButton != null){
ResultSet rs2 = null;
PreparedStatement stmt2 = null;
String sql2 = "DELETE FROM shop.goods WHERE goods_no=?";
stmt2 = conn.prepareStatement(sql2);
stmt2.setObject(1,category.get(0).get("goodsNo"));
System.out.println(stmt2);
rs2 = stmt2.executeQuery();
String filePath = request.getServletContext().getRealPath("upload");
File df = new File(filePath,(String)category.get(0).get("goodsImg"));
System.out.println(df);
df.delete();
response.sendRedirect("/shop/emp/goodsList.jsp");
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
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>

<div class="container" style="margin-top:150px; ">
<table class="table border-top">

<%
for(HashMap sm : category){

%>

<tr>
<th class="table-active">상품코드</th>
<td style="width: 300px;"><%=goodsNo%></td>
<th class="table-active">상품이름</th>
<td><%=(String)(sm.get("goodsTitle"))%></td>
<th class="table-active">상품카테고리</th>
<td><%=(String)(sm.get("goodsCategory"))%></td>
<th class="table-active">상품재고</th>
<td><%=(String)(sm.get("goodsAmount"))%></td>

</tr>

<tr>
<th class="table-active">상품이미지</th>

  
<td style = "padding: 0px"><img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>"  style="width: 300px ; height: 300px; " ></td>

<th class="table-active">상품내용</th>
<td colspan="5" style="width: 500px;" ><%=(String)(sm.get("goodsContent"))%></td>
</tr>

<tr>

<th class="table-active">상품등록날짜</th>
<td><%=(String)(sm.get("createDate"))%></td>
<th class="table-active">상품수정날짜</th>
<td colspan="5"><%=(String)(sm.get("updateDate"))%></td>

</tr>

<% 
}
%>
	</table>
	<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#deleteGoods">
  삭제하기
</button>

<!-- Modal -->
<form action="/shop/emp/goodsListOne.jsp">

	<div class="modal fade" id="deleteGoods" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">삭제하기</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	       삭제한후 되돌릴수없습니다. 정말로 삭제하시겠습니까?
	      </div>
	      <div class="modal-footer">
	      	<input type="hidden" name="deleteButton" value="delete">
	      	<input type="hidden" name="goods_no" value="<%=goodsNo%>">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소하기</button>
	        <button type="submit" class="btn btn-primary">삭제하기</button>
	      </div>
	    </div>
	  </div>
	</div>

</form>


</div>	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</body>
</html>