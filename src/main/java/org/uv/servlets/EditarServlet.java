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
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EditarServlet")
public class EditarServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int clave = Integer.parseInt(request.getParameter("clave"));
        
        try {
            Class.forName("org.postgresql.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:postgresql://172.17.0.2/mydb", "postgres", "pass")) {
                String sql = "SELECT * FROM mytable WHERE clave=?";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setInt(1, clave);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        request.setAttribute("mytable", rs);
                    }
                    rs.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("editar.jsp").forward(request, response);
    }
}

