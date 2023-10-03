<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRUD en JSP</title>
</head>
<body>
    <h1>CRUD en JSP con PostgreSQL</h1>
    
    <%-- Establecer la conexión a la base de datos --%>
    <%
        String dbURL = "jdbc:postgresql://172.17.0.2/mydb";
        String username = "postgres";
        String password = "pass";
        
        try {
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(dbURL, username, password);
            Statement statement = connection.createStatement();
            
            // Verificar si se ha enviado un formulario para insertar un nuevo registro
            if (request.getParameter("insertar") != null) {
                String nombre = request.getParameter("nombre");
                String direccion = request.getParameter("direccion");
                String telefono = request.getParameter("telefono");
                PreparedStatement insertStatement = connection.prepareStatement("INSERT INTO mytable (nombre, direccion, telefono) VALUES (?, ?, ?)");
                insertStatement.setString(1, nombre);
                insertStatement.setString(2, direccion);
                insertStatement.setString(3, telefono); 
                insertStatement.executeUpdate();
            }
            
            // Verificar si se ha enviado un formulario para eliminar un registro
            if (request.getParameter("eliminar") != null) {
                int clave = Integer.parseInt(request.getParameter("clave"));
                PreparedStatement deleteStatement = connection.prepareStatement("DELETE FROM mytable WHERE clave = ?");
                deleteStatement.setInt(1, clave);
                deleteStatement.executeUpdate();
            }
            
            if (request.getParameter("editarbutton") != null) {
                // Obtener la clave del registro a editar
                int claveEditar = Integer.parseInt(request.getParameter("clave"));
                
                // Consultar los datos del registro a editar
                String sqlSelectEditar = "SELECT * FROM mytable WHERE clave = ?";
                PreparedStatement selectEditarStatement = connection.prepareStatement(sqlSelectEditar);
                selectEditarStatement.setInt(1, claveEditar);
                ResultSet resultSetEditar = selectEditarStatement.executeQuery();
                
                if (resultSetEditar.next()) {
                    String nombreEditar = resultSetEditar.getString("nombre");
                    String direccionEditar = resultSetEditar.getString("direccion");
                    String telefonoEditar = resultSetEditar.getString("telefono");
        %>
        <!-- Formulario para editar un registro -->
        <h2>Editar registro</h2>
        <form method="post">
            <input type="hidden" name="clave_editar" value="<%= claveEditar %>">
            Nombre: <input type="text" name="nombre_editar" value="<%= nombreEditar %>" required><br>
            Dirección: <input type="text" name="direccion_editar" value="<%= direccionEditar %>" required><br>
            Teléfono: <input type="text" name="telefono_editar" value="<%= telefonoEditar %>" required><br>
            <input type="submit" name="actualizar" value="Actualizar">
        </form>
        <%
                }
                resultSetEditar.close();
                selectEditarStatement.close();
            }
            
            if (request.getParameter("actualizar") != null) {
            int claveEditar = Integer.parseInt(request.getParameter("clave_editar"));
            String nombreEditar = request.getParameter("nombre_editar");
            String direccionEditar = request.getParameter("direccion_editar");
            String telefonoEditar = request.getParameter("telefono_editar");

            // Realizar la actualización en la base de datos
            try {
                String sqlUpdate = "UPDATE mytable SET nombre=?, direccion=?, telefono=? WHERE clave=?";
                PreparedStatement updateStatement = connection.prepareStatement(sqlUpdate);
                updateStatement.setString(1, nombreEditar);
                updateStatement.setString(2, direccionEditar);
                updateStatement.setString(3, telefonoEditar);
                updateStatement.setInt(4, claveEditar);
                updateStatement.executeUpdate();
                updateStatement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

            // Consulta para obtener todos los registros
            String sqlSelect = "SELECT * FROM mytable";
            ResultSet resultSet = statement.executeQuery(sqlSelect);
    %>

    
    <%
        if (request.getParameter("editarbutton") == null) {
    %>
    <!-- Formulario para agregar un nuevo registro -->
    <h2>Agregar nuevo registro</h2>
    <form method="post">
        Nombre: <input type="text" name="nombre" required><br>
        Dirección: <input type="text" name="direccion" required><br>
        Teléfono: <input type="text" name="telefono" required><br>
        <input type="submit" name="insertar" value="Insertar">
    </form>
    
    <%
        }
    %>
    <!-- Tabla para mostrar registros existentes -->
    <h2>Registros existentes</h2>
    <table border="1">
        <tr>
            <th>Clave</th>
            <th>Nombre</th>
            <th>Dirección</th>
            <th>Teléfono</th>
            <th>Editar</th>
            <th>Eliminar</th>
        </tr>
        <%
            // Iterar a través de los resultados de la consulta
            while (resultSet.next()) {
                int clave = resultSet.getInt("clave");
                String nombre = resultSet.getString("nombre");
                String direccion = resultSet.getString("direccion");
                String telefono = resultSet.getString("telefono");
        %>
        <tr>
            <td><%= clave %></td>
            <td><%= nombre %></td>
            <td><%= direccion %></td>
            <td><%= telefono %></td>
            <td>
                <form method="post">
                    <input type="hidden" name="clave" value="<%= clave %>">
                    <input type="submit" name="editarbutton" value="Editar">
                </form>
            </td>
            <td>
                <form method="post">
                    <input type="hidden" name="clave" value="<%= clave %>">
                    <input type="submit" name="eliminar" value="Eliminar <%= clave %>">
                </form>
            </td>
        </tr>
        <%
            }
            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Cierre de la conexión y otros recursos
    %>
    </table>
    

</body>
</html>
