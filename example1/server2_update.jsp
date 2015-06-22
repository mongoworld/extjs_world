<%@page import="org.json.simple.JSONValue"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try{
	Object obj = JSONValue.parse(request.getParameter("data"));
	JSONObject req=(JSONObject)obj;
	JSONObject res = new JSONObject();
	
	/**
	*	JDBC 정보 설정 (MySQL)
	*/
	String url = "jdbc:mysql://localhost:3306/test";
	String id = "ID";
	String pwd = "PASSWORD";                             
	
	Class.forName("com.mysql.jdbc.Driver");
	conn=DriverManager.getConnection(url,id,pwd);
	
	String query = "UPDATE blog SET title = ?, contents = ?, create_date = ?, author = ? WHERE idx = ? ";
	System.out.println(query);
	pstmt = conn.prepareStatement(query);
	
	pstmt.setString(1, (String)req.get("title"));
	pstmt.setString(2, (String)req.get("contents"));
	pstmt.setString(3, (String)req.get("create_date"));
	pstmt.setString(4, (String)req.get("author"));
	pstmt.setInt(5, Integer.parseInt((String)req.get("pk")));
	
	int count = pstmt.executeUpdate();
	
	res.put("success", true);
	
	response.setContentType("text/plain; charset=UTF-8");
	PrintWriter pw = response.getWriter();
	pw.print(res);
	pw.flush();
	pw.close();
}catch(Exception e){
	e.printStackTrace();
}
%>