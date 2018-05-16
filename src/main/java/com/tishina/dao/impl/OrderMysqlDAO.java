package com.tishina.dao.impl;

import com.tishina.dao.OrderDAO;
import com.tishina.dao.TishinaDataSource;
import com.tishina.dao.util.ResultSetHandler;
import com.tishina.model.Book;
import com.tishina.model.Client;
import com.tishina.model.Order;

import java.sql.JDBCType;
import java.sql.ResultSet;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class OrderMysqlDAO implements OrderDAO {
    private static final String GET_ORDER_BY_ID_QUERY =
            "select o.id order_id, o.creation_date, o.completion_date, o.status, \n" +
            "       c.id client_id, c.name client_name, c.login client_login, \n" +
            "       b.id book_id, b.name book_name, \n" +
            "       ob.*\n" +
            "         from bshop.order o \n" +
            "         join client c on o.client_id = c.id\n" +
            "    left join order_book ob on o.id = ob.order_id\n" +
            "    left join book b on ob.book_id = b.id\n" +
            " where order_id = ?";

    private static final String INSERT_INTO_ORDER_TABLE_QUERY =
            "insert into bshop.order(id, client_id, status, completion_date, creation_date) values(null, ?, 'Active', null, now())";
    private static final String INSERT_INTO_ORDER_BOOK_TABLE_QUERY =
            "insert into order_book(order_id, book_id, amount) values(?, ?, ?)";

    @Override
    public Order getOrder(Integer id) {
        return (Order) TishinaDataSource.executePreparedStatement(
                GET_ORDER_BY_ID_QUERY,
                new Object[][]{{JDBCType.INTEGER, id}},
                new ResultSetHandler<Order>() {
                    @Override
                    public Order handle(ResultSet rs) throws Exception {
                        if (!rs.next()) return null;

                        Client client = new Client(rs.getInt("client_id"),
                                rs.getString("client_name"),
                                rs.getString("client_login"));

                        Integer orderId = rs.getInt("order_id");
                        Date startDate = rs.getDate("creation_date");
                        Date completionDate = rs.getDate("completion_date");
                        String orderStatus = rs.getString("status");
                        Map<Book, Integer> books = new HashMap<>();
                        do {
                            Book book = new Book(rs.getInt("book_id"),
                                    rs.getString("book_name"));
                            books.put(book, rs.getInt("amount"));
                        } while( rs.next());

                        Order order = new Order(orderId, client, books);
                        order.setCompletionDate(completionDate);
                        order.setStatus(orderStatus);
                        order.setStartDate(startDate);
                        return order;
                    }
                });

    }

    @Override
    public Integer createOrder(Order order) {
        Integer orderId = TishinaDataSource.executeCreateStatementAndGetAutoincrementedId(
                INSERT_INTO_ORDER_TABLE_QUERY,
                new Object[][]{{JDBCType.INTEGER, order.getClient().getId()}});
        Objects.requireNonNull(orderId,
                "Unable to insert into bshop.order. Probably id was not autogenerated in database");
        order.setId(orderId);

        for (Map.Entry<Book,Integer> bookAndAmount : order.getBooks().entrySet()) {
            TishinaDataSource.executeDMLStatement(
                    INSERT_INTO_ORDER_BOOK_TABLE_QUERY,
                    new Object[][]{{JDBCType.INTEGER, orderId},
                            {JDBCType.INTEGER, bookAndAmount.getKey().getId()},
                            {JDBCType.INTEGER, bookAndAmount.getValue()}});
        }

        return orderId;
    }

}