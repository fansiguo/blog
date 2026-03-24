package com.blog.repository;

import com.blog.entity.Article;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleRepository extends JpaRepository<Article, Long> {
    Page<Article> findByStatus(Article.Status status, Pageable pageable);
    Page<Article> findByCategoryIdAndStatus(Long categoryId, Article.Status status, Pageable pageable);
}
