//= require 'simplemde/dist/simplemde.min'
//= require inline-attachment/src/inline-attachment
//= require inline-attachment/src/codemirror-4.inline-attachment

document.addEventListener("DOMContentLoaded", function(event) {
    var inlineAttachmentConfig = {
        uploadUrl: 'attach',
        extraHeaders: {
            'X-CSRF-Token': Rails.csrfToken()
        }
    };

    var simplemde = new SimpleMDE({
        element: document.getElementById("simple-mde"),
        forceSync: true,
        parsingConfig: {
            allowAtxHeaderWithoutSpace: true,  // space_after_headers
            strikethrough: true, // strikethrough
            underscoresBreakWords: false // no_intra_emphasis
        },
        renderingConfig: {
            codeSyntaxHighlighting: false // need to add if we want
        },
        status: false,
        toolbar: ["bold", "italic", "|",
            "heading-1", "heading-2", "heading-3", "|",
            "unordered-list", "ordered-list", "quote", "|",
            "link", "image", "table", "horizontal-rule", "|",
            "undo", "redo", "|",
            {
                name: "guide",
                action: "/markdown-guide",
                className: "fa fa-question-circle",
                title: "Markdown Guide",
                default: true
            }
        ],
    });
    inlineAttachment.editors.codemirror4.attach(simplemde.codemirror, inlineAttachmentConfig);
});