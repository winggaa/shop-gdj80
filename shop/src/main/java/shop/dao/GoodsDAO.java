package shop.dao;
import java.sql.*;
import java.util.*;
import shop.dao.*;

public class GoodsDAO {
	
	
	
	public static ArrayList<HashMap<String, Object>> goodsList(String category ,String searchWord , int startRow , int rowPerPage) throws Exception{
		Connection conn = DBHelper.getConnection();
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

		
		ResultSet rs2 = stmt2.executeQuery();
		
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

		return goodsList;
	}
		public static void insertCategory(String insertCategory) throws Exception {
			Connection conn = DBHelper.getConnection();
			ResultSet rs3 = null;
			PreparedStatement stmt3 = null;
			String sql3 = null;
			sql3 = "insert into category(category) values(?)";
			//System.out.println(request.getParameter("insertCategory")+"<---insertcategory");
			if(insertCategory != null && insertCategory !=""){
			
			stmt3 = conn.prepareStatement(sql3);
			stmt3.setString(1, insertCategory);
			//System.out.println(stmt3);
			rs3 = stmt3.executeQuery();
			
			return ;
			}
		}
		
		public static void deleteCategory(String deleteCategory) throws Exception {
			Connection conn = DBHelper.getConnection();
			ResultSet rs4 = null;
			PreparedStatement stmt4 = null;
			String sql4 = null;
			sql4 = "DELETE FROM category WHERE category=?";
			//System.out.println(deleteCategory+ "<---deleteCategory");
			if(deleteCategory != null){
			stmt4 = conn.prepareStatement(sql4);
			stmt4.setString(1, deleteCategory);
			rs4 = stmt4.executeQuery();
			}
		}
	
		
		
	
}
