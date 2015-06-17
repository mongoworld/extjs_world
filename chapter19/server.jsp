<%@page import="java.io.PrintWriter"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
try{
	JSONObject jsonObject = new JSONObject();
	JSONArray jsonArray = new JSONArray();
	JSONObject subObject =  null;
	
	int start = Integer.parseInt(request.getParameter("start"));
	int end = Integer.parseInt(request.getParameter("limit"));
	int total = 0;
	
	/**
	*	JDBC 정보 설정 (MySQL)
	*/
	String url = "jdbc:mysql://HOST:PORT/DBNAME";
	String id = "ID";
	String pwd = "PASSWORD";                             
	
	Class.forName("com.mysql.jdbc.Driver");
	conn=DriverManager.getConnection(url,id,pwd);
	stmt = conn.createStatement();
	
	/**
	*	전체카운트 조회
	*/
	String count_sql = "SELECT COUNT(*) FROM blog";
	rs = stmt.executeQuery(count_sql);
	if(rs.next()) {
		total = rs.getInt(1);
	}
	
	/**
	*	목록조회 + 페이징
	*/
	String list_sql = "SELECT * FROM blog LIMIT " + start + " , " + end;
	rs = stmt.executeQuery(list_sql);
	
	while(rs.next()){
		subObject = new JSONObject();
		subObject.put("title", rs.getString("title"));
		subObject.put("contents", rs.getString("contents"));
		subObject.put("author", rs.getString("author"));
		subObject.put("create_date", rs.getString("create_date"));
		jsonArray.add(subObject);
	}
	
	jsonObject.put("total", total);
	jsonObject.put("success", true);
	jsonObject.put("data", jsonArray);
	
	response.setContentType("text/plain; charset=UTF-8");
	PrintWriter pw = response.getWriter();
	pw.print(jsonObject);
	pw.flush();
	pw.close();
}catch(Exception e){
	e.printStackTrace();
}
%>