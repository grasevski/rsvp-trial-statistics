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
  static final class RsvpTable {
    public final String name, tablename;

    public RsvpTable(final String name, final String tablename) {
      this.name = name;
      this.tablename = tablename;
    }
  }

  public static void main(final String[] args) {
    final String conStr = "jdbc:oracle:thin:@SMARTR510-SERV1:1521:orcl";
    final String stmt = "select gender, w, r, score, count(*) from "
      + "(select userid, getweek(created) w, score from %s) x join "
      + "userrule u on u.userid=x.userid where w between 1 and 6 "
      + "group by gender, w, r, score order by gender, w, r, score";
    final String filename = args[2] + "/%s_%d_%d_%d.csv";
    final List<RsvpTable> tables = new ArrayList<RsvpTable>();
    final Scanner sc = new Scanner(System.in);
    while (sc.hasNextLine()) {
      final String[] line = sc.nextLine().split(",");
      tables.add(new RsvpTable(line[0], line[1]));
    }
    try {
      final Connection con = DriverManager.getConnection(conStr, args[0], args[1]);
      final Statement st = con.createStatement();
      for (RsvpTable table : tables) {
        System.out.println(table.name);
        final String s = String.format(stmt, table.tablename);
        final ResultSet rs = st.executeQuery(s);
        int gender = -1, week = -1, rule = -1;
        PrintWriter out = null;
        BufferedWriter bw = null;
        while (rs.next()) {
          final int g=rs.getInt(1), w=rs.getInt(2), r=rs.getInt(3);
          if (g != gender || w != week || r != rule) {
            final String f = String.format(filename, table.name, g, w, r);
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
