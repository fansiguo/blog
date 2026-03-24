package com.blog.service;

import com.blog.dto.ArticleDTO;
import com.blog.entity.Article;
import com.blog.entity.Category;
import com.blog.entity.Tag;
import com.blog.repository.ArticleRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@Service
public class ArticleService {
    private final ArticleRepository articleRepository;
    private final CategoryService categoryService;
    private final TagService tagService;

    public ArticleService(ArticleRepository articleRepository,
                          CategoryService categoryService,
                          TagService tagService) {
        this.articleRepository = articleRepository;
        this.categoryService = categoryService;
        this.tagService = tagService;
    }

    public Page<Article> findPublished(Pageable pageable) {
        return articleRepository.findByStatus(Article.Status.PUBLISHED, pageable);
    }

    public Page<Article> findAll(Pageable pageable) {
        return articleRepository.findAll(pageable);
    }

    public Article findById(Long id) {
        return articleRepository.findById(id).orElse(null);
    }

    @Transactional
    public Article create(ArticleDTO dto) {
        Article article = new Article();
        applyDTO(article, dto);
        return articleRepository.save(article);
    }

    @Transactional
    public Article update(Long id, ArticleDTO dto) {
        Article article = articleRepository.findById(id).orElseThrow();
        applyDTO(article, dto);
        return articleRepository.save(article);
    }

    public void deleteById(Long id) {
        articleRepository.deleteById(id);
    }

    private void applyDTO(Article article, ArticleDTO dto) {
        article.setTitle(dto.getTitle());
        article.setContent(dto.getContent());
        article.setSummary(dto.getSummary());
        article.setCoverImage(dto.getCoverImage());
        article.setStatus(dto.getStatus() != null ? dto.getStatus() : Article.Status.DRAFT);

        if (dto.getCategoryId() != null) {
            Category category = categoryService.findById(dto.getCategoryId());
            article.setCategory(category);
        } else {
            article.setCategory(null);
        }

        if (dto.getTagIds() != null && !dto.getTagIds().isEmpty()) {
            Set<Tag> tags = tagService.findByIds(dto.getTagIds());
            article.setTags(tags);
        } else {
            article.getTags().clear();
        }
    }
}
