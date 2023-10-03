<%-- 
    Document   : index
    Created on : 20 sep 2023, 0:07:51
    Author     : btoarriola
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>CRUD con JSP</title>
</head>
<body>
    <h1>CRUD con JSP</h1>
    
    <!-- Formulario para Insertar -->
    <form action="InsertarServlet" method="post">
        Nombre: <input type="text" name="nombre">
        Direccion <input type="text" name="direccion">
        Teléfono: <input type="text" name="telefono">
        <input type="submit" value="Insertar">
    </form>
    
    <!-- Tabla para Mostrar Todos -->
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Direccion</th>
            <th>Teléfono</th>
            <th>Acciones</th>
        </tr>
        <%
            try {
                Class.forName("org.postgresql.Driver");
                Connection con = DriverManager.getConnection("jdbc:postgresql://172.17.0.2/mydb", "postgres", "pass");
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM mytable");
                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getInt("clave") %></td>
                        <td><%= rs.getString("nombre") %></td>
                        <td><%= rs.getString("direccion") %></td>
                        <td><%= rs.getString("telefono") %></td>
                        <td>
                            <a href="EditarServlet?clave=<%= rs.getInt("clave") %>">Editar</a>
                            <a href="BorrarServlet?clave=<%= rs.getInt("clave") %>">Borrar</a>
                        </td>
                    </tr>
        <%
                }
                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
