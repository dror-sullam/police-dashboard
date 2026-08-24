# Police Dashboard

A small police operations dashboard for a DevOps course project. It presents active cases, recent alerts, and duty roster information.

## Running locally

1. Clone the repository into the Tomcat `webapps` directory:

   ```cmd
   git clone https://github.com/dror-sullam/police-dashboard.git
   ```

2. Start Apache Tomcat.
3. Open [http://localhost:8080/police-dashboard/](http://localhost:8080/police-dashboard/).

## Test accounts

The accounts below are for local testing only. Passwords follow the same `first_last` format as the usernames.

| Name          | Username        | Password        |
| ------------- | --------------- | --------------- |
| Dror Sullam   | `dror_sullam`   | `dror_sullam`   |
| Genadi Krigan | `genadi_krigan` | `genadi_krigan` |
| Daniel Drori  | `daniel_drori`  | `daniel_drori`  |
| Shahar Cohen  | `shahar_cohen`  | `shahar_cohen`  |
| Yosef Chekol  | `yosef_chekol`  | `yosef_chekol`  |

## Project files

- `index.jsp` handles login.
- `dashboard.jsp` displays authenticated operational data.
- `about.jsp` describes the project and team.
- `users.csv` stores test user profiles and password hashes.
- `cases.csv`, `alerts.csv`, and `roster.csv` store dashboard data.
- `styles.css` contains the shared styling.
