package shop.dao;
import java.sql.*;



public class Customer {

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
