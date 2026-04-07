<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setStatus(301);
    response.setHeader("Location", request.getContextPath() + "/doctor/prescriptions");
    response.setHeader("Connection", "close");
%>
