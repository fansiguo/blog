package com.blog.dto;

import com.blog.entity.Article;
import jakarta.validation.constraints.NotBlank;
import java.util.Set;

public class ArticleDTO {
    @NotBlank(message = "标题不能为空")
    private String title;
    private String content;
    private String summary;
    private String coverImage;
    private Article.Status status;
    private Long categoryId;
    private Set<Long> tagIds;

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public Article.Status getStatus() { return status; }
    public void setStatus(Article.Status status) { this.status = status; }
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public Set<Long> getTagIds() { return tagIds; }
    public void setTagIds(Set<Long> tagIds) { this.tagIds = tagIds; }
}
