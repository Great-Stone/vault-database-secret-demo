<%@ page language="java" contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%
  Connection conn = null;
 
  try {
    Context init = new InitialContext();
    Context env = (Context)init.lookup("java:comp/env");
    DataSource ds = (DataSource) env.lookup("jdbc/mysql");
    conn = ds.getConnection();
    
    out.println("<h2>Connection Success!!</h2>");
  }catch(Exception e){
    out.println("<h2>Connection Fail!!</h2>");
    e.printStackTrace();
  }finally{
    conn.close();
  }
%>