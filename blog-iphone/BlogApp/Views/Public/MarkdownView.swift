import SwiftUI
import WebKit

struct MarkdownView: UIViewRepresentable {
    let markdown: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = buildHTML(from: markdown)
        webView.loadHTMLString(html, baseURL: URL(string: AppConfig.baseURL))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { height, _ in
                if let height = height as? CGFloat {
                    webView.frame.size.height = height
                    webView.invalidateIntrinsicContentSize()
                }
            }
        }
    }

    private func buildHTML(from markdown: String) -> String {
        // Escape for JS string
        let escaped = markdown
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "$", with: "\\$")

        return """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <script src="https://cdn.jsdelivr.net/npm/markdown-it@14.0.0/dist/markdown-it.min.js"></script>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                font-size: 16px;
                line-height: 1.9;
                color: #1a1a2e;
                background: transparent;
                padding: 0 4px;
                word-wrap: break-word;
            }
            h1, h2, h3 { font-family: Georgia, 'Noto Serif SC', serif; margin: 24px 0 12px; }
            h1 { font-size: 24px; }
            h2 { font-size: 20px; }
            h3 { font-size: 18px; }
            p { margin: 12px 0; }
            a { color: #2563eb; text-decoration: none; }
            blockquote {
                border-left: 3px solid #2563eb;
                background: #eff6ff;
                padding: 12px 16px;
                margin: 16px 0;
                font-style: italic;
                color: #4b5563;
            }
            pre {
                background: #1e293b;
                color: #e2e8f0;
                padding: 16px;
                border-radius: 8px;
                overflow-x: auto;
                margin: 16px 0;
                font-size: 14px;
            }
            code {
                background: #f3f4f6;
                color: #ef4444;
                padding: 2px 6px;
                border-radius: 4px;
                font-size: 14px;
            }
            pre code {
                background: none;
                color: inherit;
                padding: 0;
            }
            img {
                max-width: 100%;
                border-radius: 8px;
                margin: 16px 0;
            }
            ul, ol { padding-left: 24px; margin: 12px 0; }
            li { margin: 4px 0; }
            table { border-collapse: collapse; width: 100%; margin: 16px 0; }
            th, td { border: 1px solid #e5e7eb; padding: 8px 12px; text-align: left; }
            th { background: #f3f4f6; font-weight: 600; }
            hr { border: none; border-top: 1px solid #e5e7eb; margin: 24px 0; }
        </style>
        </head>
        <body>
        <div id="content"></div>
        <script>
            var md = markdownit({ html: false, linkify: true, typographer: true });
            document.getElementById('content').innerHTML = md.render(`\(escaped)`);
        </script>
        </body>
        </html>
        """
    }
}
