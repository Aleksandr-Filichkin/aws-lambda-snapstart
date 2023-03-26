package com.filichkin.blog.lambda.storage;

import com.filichkin.blog.lambda.model.Book;

public interface BookStorage {
    String TABLE_NAME = "books";

    void save(Book book);

    Book get(String id);

    Book delete(String id);

    Book update(Book book);

}
