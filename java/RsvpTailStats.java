import java.io.BufferedWriter;
import java.io.IOException;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

final class RsvpTailStats {
  static final class RsvpTable {
    public final String name, tablename;

    public RsvpTable(final String name, final String tablename) {
      this.name = name;
      this.tablename = tablename;
    }
  }

  static final class RsvpQuery {
    public final String name, cond;

    public RsvpQuery(final String name, final String cond) {
      this.name = name;
      this.cond = cond;
    }
  }

  public static void main(final String[] args) {
    final int NUM_FIELDS = 6, INTERVAL_DAYS = 28, WEEK_LENGTH = 7;
    final String stmt = "select rule, gender, placement, count(distinct u) nLHS_%1$s, count(distinct t) nRHS_%1$s, count(*) %1$s"
      + " from (select * from rule, gender, placement)"
      + " left join (select u1.userid u, u2.userid t, r, u1.gender g, placement p from %2$s x join userrule u1 on u1.userid=x.userid join temp_user u2 on u2.userid=targetuserid where %3$s)"
      + " on r=rule and g=gender and p=placement"
      + " group by rule, gender, placement"
      + " order by rule, gender, placement";
    final RsvpQuery[] queries = {
      new RsvpQuery("New2New", String.format("u1.created between x.created - %1$s and x.created and u2.created between x.created - %1$s and x.created", WEEK_LENGTH)),
      new RsvpQuery("New2all", String.format("u1.created between x.created - %1$s and x.created", WEEK_LENGTH)),
      new RsvpQuery("all2New", String.format("u2.created between x.created - %1$s and x.created", WEEK_LENGTH)),
      new RsvpQuery("act02act0", String.format("not exists (select * from temp_activity where userid in (u1.userid, u2.userid) and sent between x.created - %1$s and x.created)", INTERVAL_DAYS)),
      new RsvpQuery("act02all", String.format("not exists (select * from temp_activity where userid=u1.userid and sent between x.created - %1$s and x.created)", INTERVAL_DAYS)),
      new RsvpQuery("all2act0", String.format("not exists (select * from temp_activity where userid=u2.userid and sent between x.created - %1$s and x.created)", INTERVAL_DAYS)),
      new RsvpQuery("pop02pop0", String.format("not exists (select * from temp_activity where userid in (u1.userid, u2.userid) and received between x.created - %1$s and x.created)", INTERVAL_DAYS)),
      new RsvpQuery("pop02all", String.format("not exists (select * from temp_activity where userid=u1.userid and received between x.created - %1$s and x.created)", INTERVAL_DAYS)),
      new RsvpQuery("all2pop0", String.format("not exists (select * from temp_activity where userid=u2.userid and received between x.created - %1$s and x.created)", INTERVAL_DAYS)),
      new RsvpQuery("act0_pop02act0_pop0", String.format("not exists (select * from temp_activity where (userid=u1.userid and sent between x.created - %1$s and x.created) or (userid=u2.userid and received between x.created - %1$s and x.created))", INTERVAL_DAYS)),
      new RsvpQuery("act0_pop02all", String.format("not exists (select * from temp_activity where userid=u1.userid and (sent between x.created - %1$s and x.created or received between x.created - %1$s and x.created))", INTERVAL_DAYS)),
      new RsvpQuery("all2act0_pop0", String.format("not exists (select * from temp_activity where userid=u2.userid and (sent between x.created - %1$s and x.created or received between x.created - %1$s and x.created))", INTERVAL_DAYS))
    };
    final String conStr = "jdbc:oracle:thin:@SMARTR510-SERV1:1521:orcl";
    final String filename = args[2] + "/%s_%s.csv";
    final List<RsvpTable> tables = new ArrayList<RsvpTable>();
    final Scanner sc = new Scanner(System.in);
    while (sc.hasNextLine()) {
      final String[] line = sc.nextLine().split(",");
      tables.add(new RsvpTable(line[0], line[1]));
    }
    try {
      final Connection con = DriverManager.getConnection(conStr, args[0], args[1]);
      final Statement sth = con.createStatement();
      for (RsvpTable table : tables) {
        System.out.println(table.name);
        for (RsvpQuery query : queries) {
          System.out.println("  " + query.name);
          BufferedWriter bw = null;
          final String f = String.format(filename, table.name, query.name);
          try {bw = new BufferedWriter(new FileWriter(f));}
          catch (final IOException e) {
            throw new RuntimeException(e);
          }
          final PrintWriter out = new PrintWriter(bw);
          final String st = String.format(stmt, query.name, table.tablename, query.cond);
          final ResultSet rs = sth.executeQuery(st);
          final ResultSetMetaData md = rs.getMetaData();
          out.print(md.getColumnLabel(1));
          for (int i=2; i<=NUM_FIELDS; ++i)
            out.print(',' + md.getColumnLabel(i));
          out.println();
          while (rs.next()) {
            out.print(rs.getString(1));
            for (int i=2; i<=NUM_FIELDS; ++i)
              out.print(',' + rs.getString(i));
            out.println();
          }
          try {bw.close();} catch (final IOException e) {
            throw new RuntimeException(e);
          }
        }
      }
    } catch (final SQLException e) {throw new RuntimeException(e);}
  }
}
