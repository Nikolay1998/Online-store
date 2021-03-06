package com.tishina.dao.impl;

import com.tishina.dao.ArrivalDAO;
import com.tishina.dao.TishinaDataSource;
import com.tishina.dao.util.ResultSetHandler;
import com.tishina.model.Arrival;

import java.sql.JDBCType;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collection;

@SuppressWarnings("unchecked")
public class ArrivalMysqlDAO implements ArrivalDAO{
    private static final int ARRIVAL_COUNT_PER_SELECT = 10;
    private static final String getAllArrivalsQuery = "select id, unique_names, amount, a_date from Arrival LIMIT "+ARRIVAL_COUNT_PER_SELECT;
    private static final String getArrivalsByDateQuery = "select id, unique_names, amount, a_date from Arrival where a_date > ? and a_date < ?";

    public Collection<Arrival> getAllArrivals(){
        return (Collection<Arrival>) TishinaDataSource.executePreparedStatement(
                getAllArrivalsQuery,
                null,
                new ResultSetHandler() {
                    @Override
                    public Collection<Arrival> handle(ResultSet rs) throws Exception {
                        Collection<Arrival> arrivals = new ArrayList<>(ARRIVAL_COUNT_PER_SELECT);
                        while (rs.next()) {
                            Arrival arrival = new Arrival(rs.getInt(1),
                                    rs.getInt(2),
                                    rs.getInt(3),
                                    rs.getDate(4));
                            arrivals.add(arrival);
                        }
                        return arrivals;
                    }
                }
        );

    }

    @Override
    public Collection<Arrival> getArrivalsByDate(String from, String to) {

        return (Collection<Arrival>) TishinaDataSource.executePreparedStatement(
                getArrivalsByDateQuery,
                new Object[][] {{JDBCType.VARCHAR, from}, {JDBCType.VARCHAR, to}},
                new ResultSetHandler<Collection<Arrival>>() {
                    @Override
                    public Collection<Arrival> handle(ResultSet rs) throws Exception {
                        Collection<Arrival> arrivals = new ArrayList<>(ARRIVAL_COUNT_PER_SELECT);
                        while (rs.next()) {
                            Arrival arrival = new Arrival(rs.getInt(1),
                                    rs.getInt(2),
                                    rs.getInt(3),
                                    rs.getDate(4));
                            arrivals.add(arrival);
                        }
                        return arrivals;
                    }
                });
    };
}
