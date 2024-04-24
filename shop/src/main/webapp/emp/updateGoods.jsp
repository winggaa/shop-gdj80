<%@page import="oracle.jdbc.proxy.annotation.Pre"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.DBHelper"%>
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

<%  // goods_no값 받아오기
	int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	String update = request.getParameter("update");
	// 카테고리 선택 리스트 불러오기 위한 메소드
	ArrayList<HashMap<String,Object>> allCategory = GoodsDAO.allCategory();
%>

<% 
	Connection conn =  DBHelper.getConnection();
	//goods_no에 해당하는 db정보를 가져오는 메소드  
	ArrayList<HashMap<String,Object>> category = GoodsDAO.category(goodsNo);
	//System.out.println(category);
	String img = (String)category.get(0).get("goodsImg");
	String goodsTitle = request.getParameter("goodsTitle");
	String goodsContent = request.getParameter("goodsContent");
	String goodsCategory = request.getParameter("goodsCategory");
	
	int goodsAmount = 0;
	int goodsPrice = 0;
	if(request.getParameter("goodsAmount") != null){
	goodsAmount = Integer.parseInt (request.getParameter("goodsAmount"));
	}
	if(request.getParameter("goodsPrice") != null){
	goodsPrice = Integer.parseInt  (request.getParameter("goodsPrice"));
	}
	//int goodsPrice =  (Integer)category.get(0).get("goodsPrice");
	//int goodsAmount = (Integer)category.get(0).get("goodsAmount");
	//int goodsAmount = Integer.parseInt((String.valueOf(category.get(0).get("goodsAmount"))));
	//int goodsPrice = Integer.parseInt((String.valueOf(category.get(0).get("goodsPrice"))));
	//System.out.println(request.getParameter("update") +"<<<update?");
	//System.out.println(goodsTitle+"<<goodsTitle" + goodsContent +"<< goodsContent" + goodsAmount +"<< goodsAmount" + goodsPrice +"<<goodsPrice");
	
%>

<%
	/* 업데이트 쿼리문 */ 
	// 수정하기 버튼을 누르면 update 에 값이 들어옴. 
	if( update != null){
		// 굿즈정보수정 하는 쿼리 성공시 1 실패시 0 반환받음.
	int row	 = GoodsDAO.updateGoods(goodsTitle, goodsContent, goodsPrice, goodsAmount, goodsCategory, goodsNo);
		
		//	System.out.println(row);
	
	response.sendRedirect("/shop/emp/goodsListOne.jsp?goods_no="+goodsNo);
	}
%>

<%
	
	// File df = new File(filePath, rs.getString("filename"));
	///<------------------------ 삭제 쿼리문 --------------------------------------------------------->
	
	
	//String num = category.get(0).get("goodsNo").toString();
	
	String deleteButton = request.getParameter("deleteButton");
	
	if(deleteButton != null){
	
		System.out.print(img.equals("default.jpg"));
		
		
		// 굿즈번호에 해당하는 굿즈 삭제
	GoodsDAO.deleteGoods(goodsNo);
		// img파일의 이름이 default.jpg 라면 삭제되면 안됨
		if(!img.equals("default.jpg")){
		//파일경로 받아오기
	String filePath = request.getServletContext().getRealPath("upload");
		System.out.println(filePath);
		// goodsOne에 있는 파일이미지 로컬에서 삭제.
	File df = new File(filePath,(String)category.get(0).get("goodsImg"));
	df.delete();
		}
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
<form action="/shop/emp/updateGoods.jsp?goodsNo="<%=goodsNo%>>
<div class="container" style="margin-top:150px; ">
<table class="table border-top">

<%
for(HashMap sm : category){

%>

<tr>
<th class="table-active">상품코드</th>
<td style="width: 300px;">
<%=goodsNo%>
<input type="hidden" value="<%=(int)(sm.get("goodsNo"))%>" name="goodsNo">
</td>
<th class="table-active">상품이름</th>
<td>
<input style="height: 50px" type="text" value="<%=(String)(sm.get("goodsTitle"))%>" name="goodsTitle">
</td>
<th class="table-active">상품카테고리</th>
<td>
<select name="goodsCategory" style="margin-top: 15px">
							<option value="기타">선택</option>
							
							<%
								for(HashMap am : allCategory){
									
							%>
								<option value="<%=(String) (am.get("category"))%>"><%=(String) (am.get("category"))%></option>
							<%
								}
							%>
</select>
</td>
<th class="table-active">상품재고</th>
<td>
<input style="height: 50px" type="text" value="<%=(String)(sm.get("goodsAmount"))%>" name = "goodsAmount">
</td>
</tr>

<tr>
<th class="table-active">상품이미지</th>
<td style = "padding: 0px"><img src="/shop/upload/<%=(String) (sm.get("goodsImg"))%>"  style="width: 300px ; height: 300px;" ></td>

<th class="table-active">상품내용</th>
<td colspan="5" style="width: 500px;" >
<textarea rows="10" cols="75" name="goodsContent">
<%=(String)(sm.get("goodsContent"))%>
</textarea>
</td>
</tr>

<tr>

<th class="table-active">상품등록날짜</th>
<td><%=(String)(sm.get("createDate"))%></td>
<th class="table-active">상품수정날짜</th>
<td colspan="5"><%=(String)(sm.get("updateDate"))%></td>

</tr>

<tr>
<th class="table-active">상품가격</th>
<td>
<input style="height: 50px" type="text" value="<%=(String)(sm.get("goodsPrice"))%>" name = "goodsPrice">
</td> 
</tr>

<% 
}
%>
	</table>
	
	
	<!-- Button trigger modal -->

	
	

	<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#update">
  	수정하기
	</button>

<!-- Modal -->


	<div class="modal fade" id="update" tabindex="-1" aria-labelledby="update" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="update">수정하기</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	       수정하시겠습니까? (카테고리를 선택하지 않으면 자동적으로 기타로 분류됩니다.)
	      </div>
	      <div class="modal-footer">
	      	<input type="hidden" name="update" value="update">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소하기</button>
	        <button type="submit" class="btn btn-primary">수정하기</button>
	      </div>
	    </div>
	  </div>
	</div>

</form>


</div>	
	
</body>
</html>