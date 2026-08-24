<%@ page import="java.io.BufferedReader,java.io.FileInputStream,java.io.InputStreamReader,java.nio.charset.StandardCharsets,java.util.ArrayList,java.util.List" %>
<%!
  private List<String[]> readCsv(String csvPath) throws Exception {
    List<String[]> records = new ArrayList<String[]>();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(csvPath), StandardCharsets.UTF_8))) {
      String line;
      reader.readLine();
      while ((line = reader.readLine()) != null) {
        if (!line.trim().isEmpty()) {
          records.add(line.split(",", -1));
        }
      }
    }
    return records;
  }

  private String escapeHtml(String value) {
    return value == null ? "" : value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
  }

  private String displayNameFor(List<String[]> users, String username) {
    for (String[] user : users) {
      if (user.length >= 4 && user[0].equals(username)) {
        return user[3];
      }
    }
    return username;
  }
%>
<%
  if ("POST".equalsIgnoreCase(request.getMethod()) && "logout".equals(request.getParameter("action"))) {
    session.invalidate();
    response.sendRedirect("index.jsp");
    return;
  }
  if (session.getAttribute("username") == null) {
    response.sendRedirect("index.jsp");
    return;
  }
  String displayName = (String) session.getAttribute("displayName");
  String avatarPath = (String) session.getAttribute("avatarPath");
  String webappPath = application.getRealPath("/");
  List<String[]> users = readCsv(webappPath + "users.csv");
  List<String[]> cases = readCsv(webappPath + "cases.csv");
  List<String[]> alerts = readCsv(webappPath + "alerts.csv");
  List<String[]> roster = readCsv(webappPath + "roster.csv");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Police Dashboard</title>
    <link rel="icon" href="data:," />
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body class="dashboard-page">
    <main class="dashboard">
      <header>
        <div class="profile-summary">
          <img class="profile-avatar" src="<%= escapeHtml(avatarPath) %>" alt="Profile picture for <%= escapeHtml(displayName) %>" />
          <div>
            <h2>Officer Profile</h2>
            <p><%= escapeHtml(displayName) %></p>
          </div>
        </div>
        <h1>Command Dashboard</h1>
        <span class="status">System status: online</span>
      </header>

      <section class="panel-grid">
        <article class="panel">
          <h2>Active Cases</h2>
          <div class="table-scroll">
            <table class="data-table">
            <thead>
              <tr><th>Case</th><th>Status</th><th>Assigned</th></tr>
            </thead>
            <tbody>
              <% for (String[] record : cases) { %>
                <tr>
                  <td><strong><%= escapeHtml(record[0]) %></strong><br /><span><%= escapeHtml(record[1]) %></span></td>
                  <td><%= escapeHtml(record[2]) %></td>
                  <td><%= escapeHtml(displayNameFor(users, record[3])) %></td>
                </tr>
              <% } %>
            </tbody>
            </table>
          </div>
        </article>
        <article class="panel">
          <h2>Recent Alerts</h2>
          <div class="table-scroll">
            <table class="data-table">
            <thead>
              <tr><th>Severity</th><th>Alert</th><th>Reported</th></tr>
            </thead>
            <tbody>
              <% for (String[] record : alerts) { %>
                <tr>
                  <td><strong class="severity-<%= escapeHtml(record[1].toLowerCase()) %>"><%= escapeHtml(record[1]) %></strong></td>
                  <td><%= escapeHtml(record[2]) %></td>
                  <td><%= escapeHtml(record[3]) %></td>
                </tr>
              <% } %>
            </tbody>
            </table>
          </div>
        </article>
        <article class="panel">
          <h2>Duty Roster</h2>
          <div class="table-scroll">
            <table class="data-table">
            <thead>
              <tr><th>Officer</th><th>Shift</th><th>Status</th></tr>
            </thead>
            <tbody>
              <% for (String[] record : roster) { %>
                <tr>
                  <td><strong><%= escapeHtml(displayNameFor(users, record[0])) %></strong><br /><span><%= escapeHtml(record[1]) %></span></td>
                  <td><%= escapeHtml(record[2]) %></td>
                  <td><%= escapeHtml(record[3]) %></td>
                </tr>
              <% } %>
            </tbody>
            </table>
          </div>
        </article>
      </section>

      <div class="dashboard-actions">
        <a class="about-button" href="about.jsp">About</a>
        <form action="dashboard.jsp" method="post">
          <input type="hidden" name="action" value="logout" />
          <button class="logout-button" type="submit">Logout</button>
        </form>
      </div>
    </main>
  </body>
</html>
