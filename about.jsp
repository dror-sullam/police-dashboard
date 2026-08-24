<%@ page import="java.io.BufferedReader,java.io.FileInputStream,java.io.InputStreamReader,java.nio.charset.StandardCharsets,java.util.ArrayList,java.util.List" %>
<%!
  private List<String[]> readUsers(String csvPath) throws Exception {
    List<String[]> users = new ArrayList<String[]>();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(csvPath), StandardCharsets.UTF_8))) {
      String line;
      reader.readLine();
      while ((line = reader.readLine()) != null) {
        if (!line.trim().isEmpty()) {
          users.add(line.split(",", -1));
        }
      }
    }
    return users;
  }

  private String escapeHtml(String value) {
    return value == null ? "" : value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
  }
%>
<%
  List<String[]> teamMembers = readUsers(application.getRealPath("/users.csv"));
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About Police Dashboard</title>
    <link rel="icon" href="data:," />
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body class="dashboard-page about-page">
    <main class="dashboard about-panel">
      <header>
        <div>
          <h1>About the Project</h1>
          <p class="about-kicker">A shared view of local operations</p>
        </div>
        <span class="status">System status: online</span>
      </header>

      <section class="about-content">
        <p>The Police Dashboard brings important local activity into one clear view. It helps teams stay aware of active cases, recent alerts, and who is currently on duty across the Tel Aviv district.</p>

        <h2 class="about-section-title">Meet the Team</h2>
        <ul class="team-list">
          <% for (String[] member : teamMembers) { %>
            <li>
              <img src="<%= escapeHtml(member[2]) %>" alt="" />
              <span><%= escapeHtml(member[3]) %></span>
            </li>
          <% } %>
        </ul>
      </section>

      <a class="about-back" href="dashboard.jsp">Back to dashboard</a>
    </main>
  </body>
</html>
