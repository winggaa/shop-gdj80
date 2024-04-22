<%@page import="shop.dao.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>

<!-- Control Layer -->
<%
	// 인증분기	 : 세션변수 이름 - loginEmp
	//String loginEmp = (String) session.getAttribute("loginEmp");
	System.out.println(session.getAttribute("loginEmp")+"<<세션값");
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<% 	
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	//System.out.println(currentPage+"<<<<<current");
	int startRow = (currentPage-1)*rowPerPage;
%>
<!--  model layer -->
<%
		
	
	// JDBC API 종속된 자료구조 모델 ResultSet -> 기본 API 자료구조(ArrayList)로 변경
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	// emp 리스트 불러오는 코드 
	list = EmpDAO.selectEmpsList(startRow, rowPerPage);
	// 마지막 페이지 번호 구하기
	int lastPage = EmpDAO.row(rowPerPage);
	
%>

<!-- view layes -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</head>
<body class="container-fluid">
	<div>
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트)-->
	<!-- 주체가 서버이기때문에 include할때는 절대주소가 /shop/... 시작하지 않는다.... -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<div class= "row">
	<div class="col-2 text-bg-primary p-3">
	sidebar 자리
	</div>
	<div class="col bg-white border shadow p-3 bg-body-tertiary rounded">
		<div style="align-content: center">
		<h1 style="margin-left: 50px">사원 목록</h1>
		</div>
		
		<form action ="/emp/modifyEmpActive.jsp" >
		<table border="1" style="width:1000px; margin-left: 50px; align-content: center" >
		
	
	
		<tr>
			<th>empId	</th>
			<th>empName	</th>
			<th>empJob	</th>
			<th>hireDate</th>
			<th>active	</th>
			<th>		</th>
		</tr>
	<%
	for(HashMap<String, Object> m : list) {
		
	%>
			<tr>
				<td><%=(String) (m.get("empId"))%></td>
				<td><%=(String) (m.get("empName"))%></td>
				<td><%=(String) (m.get("empJob"))%></td>
				<td><%=(String) (m.get("hireDate"))%></td>
				<td>
				<%
				HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
				// System.out.println((Integer)(sm.get("grade"))); //
				if((Integer)(sm.get("grade")) > 0) {
					

				%>
				
				<a href="/shop/emp/modifyEmpActive.jsp?active=<%=(String)(m.get("active"))%>&empId=<%=(String)(m.get("empId"))%>">
					<%=(String) (m.get("active")) %>
					</a>
					
				<%} %>
				</td>
			</tr>
	
	
	<%
		}
	%>
	</table>
	</form>
			<nav aria-label="Page navigation example">
			<ul class="pagination">
				<li>
				<a class="page-link" href="/shop/emp/empList.jsp?currentPage=1" aria-label="Previous" style="margin-left: 320px">
	        	<span aria-hidden="true">&laquo;</span>
	      		</a>
				</li>
						<%
							if(currentPage > 1) {
						%>
								<li class="page-item">
									<a class="page-link" href="/shop/emp/empList.jsp?currentPage=1" >처음페이지</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
								</li>
						<%		
							} else {
						%>
								<li class="page-item">
									<a class="page-link disabled" href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
								</li>
						<%		
							}
						
							if(currentPage < lastPage) {
						%>
								<li class="page-item">
									<a class="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
								</li>
						<%		
							}
						%>
						<li>
						<a class="page-link" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>" aria-label="Next">
        				<span aria-hidden="true">&raquo;</span>
      					</a>
      					</li>
					</ul>			
				</nav>
				
	
  
      
    
			
		</div>
	</div>
</body>
</html>
