package shop.dao;
import java.sql.*;
import java.util.*;


public class Customer {
	// 로그인 
	// loginAction.jsp
	// parameter : String(csId)고객아이디 , String(csPw)고객 비밀번호
	// return void or int row;
	public static HashMap<String,Object> csLogin(String csId, String csPw) throws Exception {
		HashMap<String,Object> loginCs = null;
		Connection conn = DBHelper.getConnection();
		String sql = "select * from customer where mail = ? and pw = password(?)";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1 , csId);
		stmt.setString(2 , csPw);
		System.out.println(stmt);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()){
			System.out.println("로그인 성공");
			//하나의 세션변수안에 여러개의 값을 저장하기 위해서 hashmp타입을 사용
			loginCs = new HashMap<String,Object>();
			loginCs.put("csId", rs.getString("mail"));
			loginCs.put("csName", rs.getString("name"));
			loginCs.put("csGender", rs.getString("gender"));
			loginCs.put("birth", rs.getString("birth"));
			
		}
		conn.close();
		return loginCs;
	}
	

	// 회원가입 쿼리
	//checkCustomerKeyAction.jsp
	//parameter : String(메일문자열) --- 회원가입 정보 
	//return : boolean(성공하면1, 실패면 0)
	public static int insertCustomer(String csMail,String csPw ,String csName, String birth , String gender) throws Exception{

		Connection conn = DBHelper.getConnection();
		 
		String sql1 = "INSERT INTO `shop`.`customer` (`mail`, `pw`, `name`, `birth`, `gender`) VALUES (?,password(?),?,?,?);";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		stmt1.setString(1,csMail);
		stmt1.setString(2,csPw);
		stmt1.setString(3,csName);
		stmt1.setString(4,birth);
		stmt1.setString(5,gender);
		int row = stmt1.executeUpdate();
		conn.close();
		return row;
		
	}
	
	// 회원가입시 중복확인
	// addCustomerActionForm.jsp
	//parameter : String(메일문자열)
	//return : boolean(사용가능하면 true, 불가면 false)
	public static boolean checkMail(String mail) throws Exception{
		boolean result = false;
		Connection conn = DBHelper.getConnection();
		String sql = "select mail from customer where mail = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, mail);
		ResultSet rs = stmt.executeQuery();
		if(!rs.next()) {
			result = true;
		}
		conn.close();
		return result;
	}
	
}
