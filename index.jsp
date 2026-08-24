<%@ page import="java.io.BufferedReader,java.io.FileInputStream,java.io.InputStreamReader,java.nio.charset.StandardCharsets,java.security.MessageDigest,java.security.spec.KeySpec,java.util.Base64,javax.crypto.SecretKeyFactory,javax.crypto.spec.PBEKeySpec" %>
<%!
  private String[] findUser(String csvPath, String username, String password) throws Exception {
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(csvPath), StandardCharsets.UTF_8))) {
      String line;
      reader.readLine();
      while ((line = reader.readLine()) != null) {
        String[] fields = line.split(",", -1);
        if (fields.length >= 4 && fields[0].equals(username) && verifyPassword(password, fields[1])) {
          return fields;
        }
      }
    }
    return null;
  }

  private boolean verifyPassword(String password, String storedHash) throws Exception {
    String[] parts = storedHash.split("\\$", -1);
    if (parts.length != 4 || !"PBKDF2".equals(parts[0])) {
      return false;
    }
    int iterations = Integer.parseInt(parts[1]);
    byte[] salt = Base64.getDecoder().decode(parts[2]);
    byte[] expected = Base64.getDecoder().decode(parts[3]);
    KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, expected.length * 8);
    byte[] actual = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
    return MessageDigest.isEqual(actual, expected);
  }

  private String escapeHtml(String value) {
    return value == null ? "" : value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
  }
%>
<%
  String error = null;
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String[] user = null;
    if (username != null && password != null && !username.trim().isEmpty()) {
      user = findUser(application.getRealPath("/users.csv"), username.trim(), password);
    }
    if (user != null) {
      session.setAttribute("username", user[0]);
      session.setAttribute("displayName", user[3]);
      session.setAttribute("avatarPath", user[2]);
      response.sendRedirect("dashboard.jsp");
      return;
    }
    error = "Invalid credentials.";
  }
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Police Login</title>
    <link rel="icon" href="data:," />
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body class="login-page">
    <div class="login-panel">
      <h1>Police Login</h1>
      <form action="index.jsp" method="post" autocomplete="off" novalidate>
        <label class="visually-hidden" for="username">Username</label>
        <input id="username" type="text" name="username" placeholder="Username" autocomplete="off" />
        <br />
        <label class="visually-hidden" for="password">Password</label>
        <input id="password" type="password" name="password" placeholder="Password" autocomplete="new-password" />
        <br />
        <button type="submit">Login</button>
      </form>
      <% if (error != null) { %>
        <div class="login-error" role="alert"><%= escapeHtml(error) %></div>
      <% } %>
    </div>
  </body>
</html>
