package shop.dao;
import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*; 
import java.net.*;
import org.apache.catalina.ha.backend.Sender;

public class GoodsDAO {
	
	// 출력할 db 데이터값 호출
	// 
	// parameter : String category // 카테고리 분류 , String searchWord // 검색값 
	//			   int startRow // 페이징 값  , int rowPerPage // 출력할 개수 	
	// return : ArrayList<HashMap<String,Object> goodsList
	
	public static ArrayList<HashMap<String, Object>> goodsList(String category ,String searchWord , int startRow , int rowPerPage) throws Exception{
		Connection conn = DBHelper.getConnection();
	
		PreparedStatement stmt2 = null;
		String sql2 = null;
		//System.out.println(category);
			if(category == null || category.equals("null")){
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
	
		// 카테고리 삽입sql 실행용  
		// parameter : (String insertCategory) 추가기능요청용 코드.
		// return : void
	
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
		
		// 카테고리 삭제sql 실행용  
		// parameter : (String deleteCategory) 삭제기능요청용 코드.
		// return : void
		
		
		
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
		
		// 카테고리별로 보기를 선택했을때의 페이징을 위한 행의 개수 
		// /emp/goodsList.jsp
		// parameter : (String category) 카테고리값 , null일경우 전체출력
		// return : int totalRow
		
		public static int totalRow(String category) throws Exception {
			
			int totalRow = 0;
			Connection conn = DBHelper.getConnection();
			ResultSet rs = null;
			PreparedStatement stmt = null; 
			
			if(category == null || category.equals("null")) {
				String sql = "SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category ASC";
				stmt  = conn.prepareStatement(sql);
				rs = stmt.executeQuery();
				
				while(rs.next()) {
					totalRow = totalRow + rs.getInt("cnt");
				}
			} else {	String sql = "select category, count(*) cnt from goods where category = ? group by category order by category asc";
						stmt  = conn.prepareStatement(sql);
						stmt.setString(1, category);
						rs = stmt.executeQuery();
						while(rs.next()) {
						totalRow = totalRow + rs.getInt("cnt");
						}
			}
			System.out.println(totalRow +"<<<토탈로우");
			return totalRow;
			
		}
		
		// 카테고리별 행의개수를 구하기 위함
		// /emp/goodsList.jsp
		// return : ArrayList<HashMap<String, Object>> categoryList
		
		public static ArrayList<HashMap<String, Object>> categoryIndex() throws Exception {
			Connection conn = DBHelper.getConnection();
			ResultSet rs1 = null;
			PreparedStatement stmt1 = null; 
			String sql1 = "SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category ASC";
			stmt1  = conn.prepareStatement(sql1);
			rs1 = stmt1.executeQuery();
			ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>() ;

			while(rs1.next()){
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("category", rs1.getString("category"));
				m.put("cnt",	  rs1.getInt("cnt"));
				
				categoryList.add(m);
			}
			return categoryList;

	
		}
		
		// 카테고리 추가를했을때 goods에 데이터가 입력되지않으면 category에는 존재하지만 goods에는 존재하지않아 category에서 카테고리를 불러와야함 
		// /emp/goodsList.jsp
		// return : ArrayList<HashMap<String, Object>> allCategory
		
		public static ArrayList<HashMap<String,Object>> allCategory() throws Exception {
			
			Connection conn = DBHelper.getConnection();
			ArrayList<HashMap<String,Object>> allCategory = new ArrayList<HashMap<String,Object>>(); 
			ResultSet rs = null;
			PreparedStatement stmt = null;
			String sql = "select * FROM category";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
				
			while(rs.next()){
				//System.out.println(rs5.getString("category"));	
				HashMap<String,Object> ac = new HashMap<String,Object>();	
				ac.put("category", rs.getString("category"));
				ac.put("createDate", rs.getString("create_date")); 
				allCategory.add(ac);
				
			}
			return allCategory;
		}
		
		// 카테고리 상세보기를 할때 불러올 정보를 위한 테이블 
		// /emp/goodsListOne.jsp
		// return : ArrayList<HashMap<String, Object>> category
		
		public static ArrayList<HashMap<String,Object>> category(int goodsNo) throws Exception{
			// 데이터베이스 값 받아서 hashMap에 넣기
			Connection conn = DBHelper.getConnection();
			ResultSet rs1 = null;
			PreparedStatement stmt1 = null; 
			String sql1 = "select * from goods where goods_no = ?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setInt(1,goodsNo);
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
			return category;
		}
		
		
		
		public static int addGoods(String category ,String empId ,String goodsTitle,String filename,String goodsContent, int goodsPrice , int goodsAmount) throws Exception {
			Connection conn = DBHelper.getConnection();
			
			String sql1 = "INSERT INTO goods(category , emp_id, goods_title, filename ,goods_content, goods_price, goods_amount ) VALUES(?,?,?,?,?,?,?)";
			PreparedStatement stmt = conn.prepareStatement(sql1);
			stmt.setString(1, category);
			stmt.setString(2, empId);
			stmt.setString(3, goodsTitle);
			stmt.setString(4, filename);
			stmt.setString(5, goodsContent);
			stmt.setInt(6, goodsPrice);
			stmt.setInt(7, goodsAmount);
			int row = stmt.executeUpdate();
			return row;	
		}
		
		// parameter(
		public static int deleteGoods(int goodsNo) throws Exception{
			Connection conn = DBHelper.getConnection();
			//String num = category.get(0).get("goodsNo").toString();
		
			PreparedStatement stmt2 = null;
			String sql2 = "DELETE FROM shop.goods WHERE goods_no=?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setObject(1,goodsNo);
			System.out.println(stmt2);
			int row = stmt2.executeUpdate();
			return row;
			
			}
		 
		
}
		
	

