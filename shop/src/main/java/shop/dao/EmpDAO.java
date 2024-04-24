package shop.dao;
import java.sql.*;
import java.util.*;


// emp 테이블을 CRUD하는 STATIC 메서드의 컨테이너
public class EmpDAO {
	
	public static int insertEmp(String empId, String empPw , String empName,String empJob) throws Exception {
		int row = 0;
		//db 접근
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
		String sql1 = "";
		PreparedStatement stmt = conn.prepareStatement(sql1);
		
		conn.close();
		return row;
		
	}
	
	
	// HashMap<String , object> : null이면 로그인실패, 아니면성공
	// String empId, String empPw : 로그인폼에서 사용자가 입력한 id/pw
	//	empLoginAction.jsp
	// 호출코드 HashMap<String, Object> m = EmpDAO.empLogin ("admin", "1234")
	public static HashMap<String,Object> empLogin (String empId , String empPw ) throws Exception{
						
		
		Connection conn = DBHelper.getConnection(); 
		HashMap<String,Object> resultMap = null;
						
		
		
		String sql1 = "select emp_id empId, emp_name empName, grade from emp where active = 'on' and emp_id = ? and emp_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql1);
		stmt.setString(1, empId);
		stmt.setString(2, empPw);
		ResultSet rs1 = stmt.executeQuery();
		if(rs1.next()) {
			System.out.println("로그인성공");
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", rs1.getString("empId"));
			resultMap.put("empName", rs1.getString("empName"));
			resultMap.put("grade", rs1.getInt("grade"));
		} 
		
		
		
		
		
		conn.close();
		return resultMap;
	}
		// emp 리스트에 출력할 직원리스트 가져오기 
		// empList.jsp 
		// startRow == db검색 시작행 //rowPerPage == 출력할 행의개수	
		// parameter int startRow, rowPerPage
		// return ArrayList<HashMap<String, Object>> list
		public static ArrayList<HashMap<String,Object>> selectEmpsList (int startRow, int rowPerPage) throws Exception{
		
		
		// 특수한 형태의 데이터(RDMBS:mariadb)
		// -> API사용() 하여 모델(ResultSet) 취득
		// -> 일반화된 자료구조로 변경
		/*
		select emp_id empId, emp_name empName, emp_job empJob,  hire_date hireDate, active
		from emp
		order by active asc, hire_date desc
		*/
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		String sql1 = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate , active from emp order by hire_date desc limit ? , ?";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		stmt1.setInt(1, startRow);
		stmt1.setInt(2, rowPerPage);
		ResultSet rs1 = stmt1.executeQuery();
		
		//ResultSet -> ArrayList<HashMap<String, Object>>
		while(rs1.next()){
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("empId", rs1.getString("empId"));
			m.put("empName", rs1.getString("empName"));
			m.put("empJob", rs1.getString("empJob"));
			m.put("hireDate", rs1.getString("hireDate"));
			m.put("active", rs1.getString("active"));
			list.add(m);
		}
		
		conn.close();
		return list;	
	}
		// empList.jsp
		// 직원리스트 페이지의 총칼럼개수 구하기위함 
		// parameter : rowPerPage -- 표현할 직원수 
		// return: int lastPage
		
	public static int row (int rowPerPage) throws Exception {
		int totalRow = 0;
		Connection conn = DBHelper.getConnection();
		
		String sql = "select count(*) from emp";
		ResultSet rs = null;
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt("count(*)");
		}
		// System.out.println(totalRow + " <-- totalRow");
		
		int lastPage = totalRow / rowPerPage;
		
		if(totalRow%rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
		return lastPage;
		// System.out.println(lastPage + " <-- lastPage");
	}

	// modifyEmpActive.jsp
	// 직원의 active on off 상태 변경 
	// parameter : 현상태의 active 값 , 그리고 직원 아이디.
	// return: void
		public static void modifyEmpOnOff(String active , String empId) throws Exception{
		Connection conn = DBHelper.getConnection();
		ResultSet rs1 = null;
		PreparedStatement stmt1 = null; 

		String sql1 = "UPDATE `shop`.`emp` SET active = ? WHERE emp_id=?";
		stmt1 = conn.prepareStatement(sql1);
		stmt1.setString(1,active);
		stmt1.setString(2,empId );
		rs1 = stmt1.executeQuery();
	}
		
		// empOne.jsp
		// empOne의 리스트값 가져오기
		// parameter : 세션에있는 id값.
		// return: ArrayList<HashMap<String,Object>> list
		
		public static ArrayList<HashMap<String,Object>> empOneList(String loginId) throws Exception{
			Connection conn = DBHelper.getConnection();
			String sql = "SELECT emp_id , emp_name , emp_job , hire_date , create_date, update_date FROM emp WHERE emp_id = ?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1,loginId);
			System.out.println(stmt);
			ResultSet rs = stmt.executeQuery();
			ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
			
				HashMap<String,Object> e = new HashMap<String,Object>() ;
				while(rs.next()){
				e.put("empId",rs.getString("emp_id"));
				e.put("empName",rs.getString("emp_name"));
				e.put("hireDate",rs.getString("hire_date"));
				e.put("empJob",rs.getString("emp_job"));
				e.put("createDate",rs.getString("create_date"));
				e.put("updateDate",rs.getString("update_date"));
				list.add(e);
				}
				return list;
		}
		
	
	
}
