<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*,java.util.*" %> 
<% request.setCharacterEncoding("utf-8"); %>
<%@ include file = "conn_oracle.jsp" %>


<HTML>
<HEAD><TITLE>게시판(검색모드)</TITLE>
</HEAD>
<BODY>

<P>
<P align=center>
 <FONT color=#0000ff face=굴림 size=3>
 <STRONG>자유 게시판(검색모드)</STRONG>
 </FONT>
</P> 
<FORM method=post name=search action="freeboard_search.jsp">
 <TABLE border=0 width=75%>
  <TR>
   <TD align=left width=30% valign=bottom>
    [<A href="freeboard_list03.jsp">자유 게시판(일반모드)</A>]</TD>
   <TD align=right width=70% valign=bottom>
    <FONT size=2 face=굴림>
     <SELECT name=stype >
     	<!--  stype 에 넘어오는 value 값에 따라서 다르게 출력  
        <OPTION value=1 >이름 </OPTION>
	    <OPTION value=2 >제목	 </OPTION>
	    <OPTION value=3 >내용 </OPTION>
	    <OPTION value=4 >이름+제목 </OPTION>
	    <OPTION value=5 >이름+내용 </OPTION>
	    <OPTION value=6 >제목+내용 </OPTION>
	    <OPTION value=7 >이름+제목+내용 </OPTION>
     -->
     
     
<% 
      //jsp 코드 블락 : <option> 넘어오는 변수에 따라서 해당 내용을 출력 
      String cond = null ;      // SQL 쿼리를 담는 변수 : stype : 1
      int what = 1 ;   // stype 에 넘어오는 변수 int 형으로 변환해서 담는 변수 
      		// 2 : 제목 , 3 : 내용, 4: 이름 + 제목 
      String val = null ; // sval :에서 넘어오는 검색어를 담는 변수 
      
      what = Integer.parseInt(request.getParameter("stype"));  //옵션
      val = request.getParameter("sval");  //검색어 
      
      if (what == 1) {
    	  out.println ("<OPTION value=1 selected >이름 </OPTION>"); 
    	  cond = "where name like '%" + val + "%'";
      }else {
    	  out.println ("<OPTION value=1>이름 </OPTION>"); 
      }
      
      if (what == 2) {
    	  out.println ("<OPTION value=2 selected>제목	 </OPTION>"); 
    	  cond = "where subject like '%" + val + "%'";
      }else {
    	  out.println ("<OPTION value=2>제목	 </OPTION>"); 
      }
      
      if (what == 3) {
    	  out.println ("<OPTION value=3 selected>내용 </OPTION>"); 
    	  cond = "where content like '%" + val + "%'";
      }else {
    	  out.println ("<OPTION value=3 >내용 </OPTION>"); 
      }
      
      if (what == 4) {
    	  out.println ("<OPTION value=4 selected>이름+제목 </OPTION>");
    	  cond = "where name like '%" + val + "%' or subject like '%" + val + "%'";
      }else {
    	  out.println ("<OPTION value=4 >이름+제목 </OPTION>"); 
      }
      
      if (what == 5) {
    	  out.println ("<OPTION value=5 selected>이름+내용 </OPTION>"); 
    	  cond = "where name like '%" + val + "%' or content like '%" + val + "%'";
      }else {
    	  out.println ("<OPTION value=5 >이름+내용 </OPTION>"); 
      }
      
      if (what == 6) {
    	  out.println ("<OPTION value=6 selected>제목+내용 </OPTION>"); 
    	  cond = "where subject like '%" + val + "%' or content like '%" + val + "%'";
      }else {
    	  out.println ("<OPTION value=6 >제목+내용 </OPTION>"); 
      }
      
      if (what == 7) {
    	  out.println ("<OPTION value=7 selected>이름+제목+내용 </OPTION>"); 
    	  cond = "where name like '%" + val + "%' or subject like '%" + val + "%'";
    	  cond += " or content like '%" + val + "%'"; 
      }else {
    	  out.println ("<OPTION value=7 >이름+제목+내용 </OPTION>"); 
      }
      
      
%>
     </SELECT>
	</FONT>
    <INPUT type=text name="sval" value="<%=request.getParameter("sval")%>">
    <INPUT type=submit value="검색">
   </TD>
  </TR>
 </TABLE>
</FORM>
<CENTER>

<%
/*
out.println (what + "<p/>"); 
out.println (val + "<p/>"); 
if (true) return; 
*/

%>

<TABLE border=0 width=600 cellpadding=4 cellspacing=0>
 <tr align="center"> 
  <td colspan="5" height="1" bgcolor="#1F4F8F"></td>
 </tr>
 <tr align="center" bgcolor="#87E8FF"> 
  <td width="42" bgcolor="#DFEDFF"><font size="2">번호</font></td>
  <td width="340" bgcolor="#DFEDFF"><font size="2">제목</font></td>
  <td width="84" bgcolor="#DFEDFF"><font size="2">등록자</font></td>
  <td width="78" bgcolor="#DFEDFF"><font size="2">날짜</font></td>
  <td width="49" bgcolor="#DFEDFF"><font size="2">조회</font></td>
 </tr>
 <tr align="center"> 
  <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
 </tr>
 
 <%	
 	//페이징 처리 
 Vector name=new Vector();
 Vector inputdate=new Vector();
 Vector email=new Vector();
 Vector subject=new Vector();
 Vector rcount=new Vector();
 Vector keyid=new Vector();
 Vector step=new Vector();
 
 int where=1;       //현재 위치한 페이지 

 int totalgroup=0;
 int maxpages=5;			//페이징 처리부분의 2개의 페이지만 최대로 출력
 int startpage=1;
 int endpage=startpage+maxpages-1;
 int wheregroup=1;			//페이지 그룹 
 
 if (request.getParameter("go") != null) { 
  where = Integer.parseInt(request.getParameter("go"));
  wheregroup = (where-1)/maxpages + 1;
  startpage=(wheregroup-1) * maxpages+1;  
  endpage=startpage+maxpages-1; 
  
  
 } else if (request.getParameter("gogroup") != null) {
  wheregroup = Integer.parseInt(request.getParameter("gogroup"));
  startpage=(wheregroup-1) * maxpages+1;  
  where = startpage ; 
  endpage=startpage+maxpages-1; 
  
  
 }
 int nextgroup=wheregroup+1;
 int priorgroup= wheregroup-1;
 
 int nextpage=where+1;
 int priorpage = where-1;
 int startrow=0;
 int endrow=0;
 int maxrows=5;
 int totalrows=0;
 int totalpages=0;
 
 int id=0;
 	
 	//페이징 처리 블락
 
 	//검색된 내용을 출력 하는 블락  
 		
 	String sql = null; 
 	Statement stmt = null; 
 	ResultSet rs = null; 
 	
 	//cond : option 에 선택자에 따라서 다른 쿼리가 변수로 들어옴. 
 	sql = "select * from freeboard " + cond ;
 	sql += " order by id desc" ; 
 
 	
 	 out.println (sql);
 	
 	/*
 	if (true) return; 
 	 */
 	
 	stmt = conn.createStatement(); 
 	rs = stmt.executeQuery(sql); 	//
 	
 	if (!(rs.next())){
 		out.println("해당내용이 DB 에 존재 하지 않습니다. ");
 	} else {   //검색된 내용이 존재 한다면 
 		
 		do {
 			
 		    keyid.addElement(new Integer(rs.getInt("id")));
 		    name.addElement(rs.getString("name"));
 		    email.addElement(rs.getString("email"));
 		    String idate = rs.getString("inputdate");
 		    idate = idate.substring(0,8);
 		    inputdate.addElement(idate);
 		    subject.addElement(rs.getString("subject"));
 		    rcount.addElement(new Integer(rs.getInt("readcount")));
 		    step.addElement(new Integer(rs.getInt("step")));
 		}while(rs.next()); 
 	
 	
 	   totalrows = name.size();
 	   totalpages = (totalrows-1)/maxrows +1;
 	   startrow = (where-1) * maxrows;
 	   endrow = startrow+maxrows-1  ;
 	   
 	   
 	   if (endrow >= totalrows)
 	    endrow=totalrows-1;
 	   
 	   totalgroup = (totalpages-1)/maxpages +1;
 	   if (endpage > totalpages) 
 	    endpage=totalpages;

 	   for(int j=startrow;j<=endrow;j++) {
   
 %>
 
 
 <tr align="center" bgcolor="#87E8FF"> 
  <td width="42" bgcolor="#DFEDFF"><font size="2"><%= keyid.elementAt(j) %></font></td>
  <td width="340" bgcolor="#DFEDFF"><font size="2"><%= subject.elementAt(j)  %></font></td>
  <td width="84" bgcolor="#DFEDFF"><font size="2"><%= name.elementAt(j) %></font></td>
  <td width="78" bgcolor="#DFEDFF"><font size="2"><%= inputdate.elementAt(j) %></font></td>
  <td width="49" bgcolor="#DFEDFF"><font size="2"><%= rcount.elementAt(j) %></font></td>
 </tr>
 
  <%
 	   }
 
 	}
 	
 	%>
 
 <tr>
 	<td colspan = "5" height="5px"> </td>
 </tr>
 
 <tr> 
 	<td colspan = "5" align="center"> 

 <% 
 	
 	//페이징 출력 부분 
 	
 	
 if (wheregroup > 1) {
  out.print("[<A href=freeboard_search.jsp?gogroup=1"); 
  out.print("&stype="+ what+"&sval=" + val +">처음</A>]");
  out.print("[<A href=freeboard_search.jsp?gogroup="+priorgroup);
  out.print("&stype="+ what+"&sval=" + val +">이전</A>]");
 } else {
  out.println("[처음]") ;
  out.println("[이전]") ;
 }
 if (name.size() !=0) {
  for(int jj=startpage; jj<=endpage; jj++) {
   if (jj==where) 
    out.println("["+jj+"]") ;
   else {
   out.print("[<A href=freeboard_search.jsp?go="+jj);
   out.print("&stype="+ what+"&sval=" + val +">" + jj + "</A>]") ;
   }
  }
 }
 if (wheregroup < totalgroup) {
  out.print("[<A href=freeboard_search.jsp?gogroup="+ nextgroup);
  out.print("&stype="+ what+"&sval=" + val +">다음</A>]");
  out.print("[<A href=freeboard_search.jsp?gogroup="+totalgroup); 
  out.print("&stype="+ what+"&sval=" + val +">마지막</A>]");
 } else {
  out.println("[다음]");
  out.println("[마지막]");
 }
 out.println ("검색된 글 수 :"+totalrows);
 
 %>
 </td>
 </tr>
 
 
</TABLE>
 
</BODY>
</HTML>