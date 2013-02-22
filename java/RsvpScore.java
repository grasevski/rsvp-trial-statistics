import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

final class RsvpScore {
  static final class RsvpQuery {
    public final String name, st;

    public RsvpQuery(final String name, final String st) {
      this.name = name;
      this.st = st;
    }
  }

  public static void main(final String[] args) {
    final String conStr = "jdbc:oracle:thin:@SMARTR510-SERV1:1521:orcl";
    final String filename = args[2] + "/%s_%d_%d_%d.csv";
    final List<RsvpQuery> queries = new ArrayList<RsvpQuery>();
    final Scanner sc = new Scanner(System.in);
    while (sc.hasNextLine()) {
      String line = sc.nextLine();
      if (line.startsWith("--")) {
        final String name = line.substring(2);
        line = "";
        while (sc.hasNextLine()) {
          line += " " + sc.nextLine();
          if (line.endsWith(";")) {
            line = line.substring(0, line.length() - 1);
            break;
          }
        }
        queries.add(new RsvpQuery(name, line));
      }
    }
    try {
      final Connection con = DriverManager.getConnection(conStr, args[0], args[1]);
      final Statement st = con.createStatement();
      for (RsvpQuery query : queries) {
        System.out.println(query.name);
        final ResultSet rs = st.executeQuery(query.st);
        int gender = -1, week = -1, rule = -1;
        PrintWriter out = null;
        BufferedWriter bw = null;
        while (rs.next()) {
          final int g=rs.getInt(1), w=rs.getInt(2), r=rs.getInt(3);
          if (g != gender || w != week || r != rule) {
            final String f = String.format(filename, query.name, g, w, r);
            gender = g;
            week = w;
            rule = r;
            try {
              if (bw != null) bw.close();
              bw = new BufferedWriter(new FileWriter(f));
            } catch (final IOException e) {
              throw new RuntimeException(e);
            }
            out = new PrintWriter(bw);
          }
          out.println(rs.getInt(4) + "," + rs.getInt(5));
        }
        if (bw != null) try {bw.close();}
        catch (final IOException e) {throw new RuntimeException(e);}
      }
    } catch (final SQLException e) {throw new RuntimeException(e);}
  }
}
