package com.blog.controller;

import com.blog.entity.Article;
import com.blog.service.ArticleService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/articles")
public class ArticleController {
    private final ArticleService articleService;

    public ArticleController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping
    public Page<Article> list(@RequestParam(defaultValue = "0") int page,
                              @RequestParam(defaultValue = "10") int size) {
        return articleService.findPublished(
                PageRequest.of(page, Math.min(size, 100), Sort.by(Sort.Direction.DESC, "createdAt")));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Article> detail(@PathVariable Long id) {
        Article article = articleService.findById(id);
        if (article == null || article.getStatus() != Article.Status.PUBLISHED) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(article);
    }
}
