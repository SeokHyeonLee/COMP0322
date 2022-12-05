<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>

<%@ page language="java" import="java.text.*, java.sql.*"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="config.Properties"%>

<%
int column = 4;
String src = request.getParameter("src");
String age = request.getParameter("age");
String bustype = request.getParameter("bustype");
String fee = request.getParameter("fee");
String prid = request.getParameter("prid");


Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String serverIP = Properties.serverIP;
String strSID = Properties.strSID;
String portNum = Properties.portNum;
String user = Properties.user;
String pass = Properties.pass;
String url = "jdbc:oracle:thin:@" + serverIP + ":" + portNum + ":" + strSID;
String sql = null;;

int num = 0;

Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);
%>

<%
if (src.equals("select")) {
sql = "SELECT * FROM PRICE WHERE 1=1 ";
if (age != "") 
	sql += "AND age = '" + age + "' ";

if (bustype != "") 
	sql += "AND bustype = '" + bustype + "' ";

if (fee != "") 
	sql += "AND fee = '" + fee + "' ";

if (prid != "")
	sql += "AND prid = '" + prid + "' ";
} else if (src.equals("insert")) {
	if (age != "" || bustype != "" || fee != "" || prid != "") {
		sql = "INSERT INTO price VALUES(";
		sql += "'" + age + "', '" + bustype + "', '" + fee + "', '" + prid;
		sql += "')";
	}
} else if (src.equals("delete")) {
	sql = "DELETE PRICE WHERE 1=1  ";
	if (age != "")
		sql += "AND DBID = '" + age + "' ";
	if (bustype != "")
		sql += "AND bustype = '" + bustype + "' ";
	if (fee != "")
		sql += "AND fee = '" + fee + "' ";
	if (prid != "")
		sql += "AND prid = '" + prid + "' ";
}

 System.out.println(sql);

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Page: Price</title>
</head>
<body>
	<div>
	<%
		try {
			if (src.equals("select")) {
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
		%>

		<table border="1">
			<thead>
				<tr>
					<th>age</th>
					<th>bustype</th>
					<th>fee</th>
					<th>prid</th>
				</tr>
			</thead>
			<tbody>

				<% while (rs.next()) {
					num++;
				%>
				
				<tr>
					
					<% for (int i = 1; i <= column; i++) {
					%>
					<td><%=rs.getString(i)%></td>
					<%} %>
				</tr>
				<%} %>
			</tbody>
		</table>
		<%=num %>개
		<%
		}
		%>
		<%
		if (src.equals("insert")) {
			if (age != "" || bustype != "" || fee != "" || prid != "") {
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
			} else {
		%>
		NO BLANKS!
		<%
		}
		%>
		<%=sql%>
		<%
		}
		} catch (Exception e) {
		%>
		Exception Occur
		<%
		}
		%>
	</div>
</body>
</html>