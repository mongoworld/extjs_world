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
	
	//Clicked idx (client Key = id)
	String click_node = request.getParameter("node");
	
	/**
	*	JDBC 정보 설정 (MySQL)
	*/
	String url = "jdbc:mysql://HOST:PORT/DBname";
	String id = "ID";
	String pwd = "PASSWORD";                             
	
	Class.forName("com.mysql.jdbc.Driver");
	conn=DriverManager.getConnection(url,id,pwd);
	stmt = conn.createStatement();
	
	/**
	*	목록조회 + 페이징
	*/
	String list_sql = " SELECT a.idx, a.text, (SELECT COUNT(*) "; 
		   list_sql += "					    FROM treedata b "; 
		   list_sql += "					   WHERE b.parent_idx = a.idx) count "; 
		   list_sql += "  FROM treedata a ";
		   list_sql += " WHERE a.parent_idx = " + click_node;
	
	rs = stmt.executeQuery(list_sql);
	
	while(rs.next()){
		subObject = new JSONObject();
		subObject.put("id", rs.getInt("idx"));
		subObject.put("text", rs.getString("text"));
		//child node presence
		if(rs.getInt("count") > 0) {
			subObject.put("expanded", false);
		//child node does not presence
		} else {
			subObject.put("leaf", true);
		}
		jsonArray.add(subObject);
	}
	
	jsonObject.put("success", true);
	jsonObject.put("children", jsonArray);
	
	response.setContentType("text/plain; charset=UTF-8");
	PrintWriter pw = response.getWriter();
	pw.print(jsonObject);
	pw.flush();
	pw.close();
}catch(Exception e){
	e.printStackTrace();
}
%>