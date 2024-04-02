<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>

<!-- Control Layer -->
<%
	// 인증분기	 : 세션변수 이름 - loginEmp
	//String loginEmp = (String) session.getAttribute("loginEmp");
	
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
	System.out.println(currentPage+"<<<<<current");
	int startRow = (currentPage-1)*rowPerPage;
%>
<!--  model layer -->
<%
	// 특수한 형태의 데이터(RDMBS:mariadb)
	// -> API사용() 하여 모델(ResultSet) 취득
	// -> 일반화된 자료구조로 변경
	/*
	select emp_id empId, emp_name empName, emp_job empJob,  hire_date hireDate, active
	from emp
	order by active asc, hire_date desc
	*/	
	Class.forName("org.mariadb.jdbc.Driver");
	ResultSet rs1 = null;
	Connection conn = null;
	PreparedStatement stmt1 = null; 
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	String sql1 = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate , active from emp order by hire_date desc limit ? , ?";
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setInt(1, startRow);
	stmt1.setInt(2, rowPerPage);
	rs1 = stmt1.executeQuery();
	
	// JDBC API 종속된 자료구조 모델 ResultSet -> 기본 API 자료구조(ArrayList)로 변경
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	
	//ResultSet -> ArrayList<HashMap<String, Object>>
	while(rs1.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empId", rs1.getString("empId"));
		m.put("empName", rs1.getString("empName"));
		m.put("empJob", rs1.getString("empJob"));
		m.put("hireDate", rs1.getString("hireDate"));
		m.put("active", rs1.getString("active"));
		list.add(m);
		System.out.println(rs1);	
		//JDBC API 사용이 끝났다면 DB자원들을 반납
	/*	stmt1.close();
		rs1.close();
		conn.close();
							*/
	}
	int totalRow = 0;
	String sql2 = "select count(*) from emp";
	ResultSet rs2 = null;
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	System.out.println(totalRow + " <-- totalRow");
	
	int lastPage = totalRow / rowPerPage;
	
	if(totalRow%rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println(lastPage + " <-- lastPage");
%>

<!-- view layes -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1>사원 목록</h1>
	<a href="/shop/emp/empLogout.jsp">로그아웃</a>
	<form action ="/emp/modifyEmpActive.jsp" >
	<table border="1">
	
	
	
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
				<a href="/shop/emp/modifyEmpActive.jsp?active=<%=(String) (m.get("active"))%>&empId=<%=(String)(m.get("empId"))%>">
					<%=(String) (m.get("active")) %>
					</a>
				</td>
			</tr>
	
	
	<%
		}
	%>
	</table>
	</form>
			
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
									<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
								</li>
								<li>
									<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
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
