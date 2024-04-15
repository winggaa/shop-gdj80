package shop.dao;

import java.io.FileReader;
import java.sql.*;
import java.util.Properties;

public class DBHelper {
	
	public static Connection getConnection() throws Exception {
		
		Class.forName("org.mariadb.jdbc.Driver");
		
		//로컬 pc의 properties파일 읽어 오기
		FileReader fr = new FileReader("d:\\dev\\auth\\mariadb.Properties");
		Properties prop = new Properties();
		prop.load(fr);
		System.out.println(prop.getProperty("id") + "<<<id");
		System.out.println(prop.getProperty("pw") + "<<<pw");
		String id = prop.getProperty("id");
		String pw = prop.getProperty("pw");
		
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop",id, pw);
		return conn ;
	}

}
