<%@page import="java.io.PrintWriter"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	JSONObject jsonObject = new JSONObject();
	
	jsonObject.put("param1", request.getParameter("param1"));
	jsonObject.put("param2", request.getParameter("param2"));
	jsonObject.put("result", "<h1>HELLO WORLD</h1>");
	
	response.setContentType("text/plain; charset=UTF-8");
	PrintWriter pw = response.getWriter();
	pw.print(jsonObject);
	pw.flush();
	pw.close();
%>
