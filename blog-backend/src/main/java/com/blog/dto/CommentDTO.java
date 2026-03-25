package com.blog.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class CommentDTO {
    @NotBlank(message = "昵称不能为空")
    @Size(max = 50)
    private String nickname;

    @Size(max = 100)
    private String email;

    @NotBlank(message = "评论内容不能为空")
    @Size(max = 2000)
    private String content;

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
