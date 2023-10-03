/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package org.uv.servlets;

/**
 *
 * @author btoarriola
 */
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/InsertarServlet")
public class InsertarServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        
        try {
            Class.forName("org.postgresql.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:postgresql://172.17.0.2/mydb", "postgres", "pass")) {
                String sql = "INSERT INTO mytable (nombre, direccion, telefono) VALUES (?, ?, ?)";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, nombre);
                    pstmt.setString(2, direccion);
                    pstmt.setString(3, telefono);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("index.jsp");
    }
}

