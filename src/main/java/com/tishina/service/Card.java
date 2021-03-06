package com.tishina.service;

import com.tishina.dao.BookDAO;
import com.tishina.dao.DAOFactoryHolder;
import com.tishina.model.Book;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Card {

    private Map<Integer, Integer> books = new HashMap<>(); //<bookId, amount>

    public synchronized void addBook(Integer bookId, Integer amount) {
        Integer existingAmountInOrder = books.get(bookId);
        if (existingAmountInOrder == null) {
            existingAmountInOrder = 0;
        }
        books.put(bookId, existingAmountInOrder+amount);
    }

    public boolean isEmpty() {return books.isEmpty();}

    public synchronized List<Book> getBooks() {
        List<Book> result = new ArrayList<>(books.size());
        BookDAO bookDAO = DAOFactoryHolder.getDAOFactory().getBookDAO();
        for (Map.Entry<Integer, Integer> bookAndAmountEntry: books.entrySet()) {
            Book book = bookDAO.getById(bookAndAmountEntry.getKey());
            book.setOrderedAmount(bookAndAmountEntry.getValue());
            result.add(book);
        }
        return result;
    }

    public static Card getCard(HttpSession session) {
        Card card = (Card) session.getAttribute("card");
        if (card == null) {
            card = new Card();
            session.setAttribute("card", card);
        }

        return card;
    }

    public void clearCard() {
        books.clear();
    }

    public double calculatePrice() {
        BookDAO bookDAO = DAOFactoryHolder.getDAOFactory().getBookDAO();
        double sum = 0;
        for (Map.Entry<Integer, Integer> bookAndAmountEntry: books.entrySet()) {
            Book book = bookDAO.getById(bookAndAmountEntry.getKey());
            sum = sum + book.getPrice() * bookAndAmountEntry.getValue();
        }
        return sum;
    }

}
