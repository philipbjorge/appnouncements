//= require 'simplemde/dist/simplemde.min'
//= require inline-attachment/src/inline-attachment
//= require inline-attachment/src/codemirror-4.inline-attachment

function throttle(func, wait, options) {
    var context, args, result;
    var timeout = null;
    var previous = 0;
    if (!options) options = {};
    var later = function () {
        previous = options.leading === false ? 0 : Date.now();
        timeout = null;
        result = func.apply(context, args);
        if (!timeout) context = args = null;
    };
    return function () {
        var now = Date.now();
        if (!previous && options.leading === false) previous = now;
        var remaining = wait - (now - previous);
        context = this;
        args = arguments;
        if (remaining <= 0 || remaining > wait) {
            if (timeout) {
                clearTimeout(timeout);
                timeout = null;
            }
            previous = now;
            result = func.apply(context, args);
            if (!timeout) context = args = null;
        } else if (!timeout && options.trailing !== false) {
            timeout = setTimeout(later, remaining);
        }
        return result;
    };
};

function init(uuid) {
    var inlineAttachmentConfig = {
        uploadUrl: 'attach',
        extraHeaders: {
            'X-CSRF-Token': Rails.csrfToken()
        }
    };
    var simplemde = new SimpleMDE({
        element: document.getElementById("simple-mde"),
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
            "link", "image", "horizontal-rule", "|",
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

    var previewRequest = new XMLHttpRequest();
    var preview = function() {
        console.log("previewing");
        previewRequest.onreadystatechange = null;
        previewRequest.abort();

        previewRequest = new XMLHttpRequest();
        previewRequest.onreadystatechange = function () {
            if (previewRequest.readyState != 4) {
                return false
            }

            var preview = $("#preview")[0];
            preview.contentDocument.open();
            preview.contentDocument.write(previewRequest.responseText);
            preview.contentDocument.close();
        };
        previewRequest.open("POST", "/api/v1/release_notes/" + uuid + "/preview");
        previewRequest.send(new FormData($("#release_edit")[0]));
    };
    var throttledPreview = throttle(preview, 200, {leading: false, trailing: true});

    $("#release_edit").on("input", throttledPreview);
    simplemde.codemirror.on("change", function() {
        simplemde.codemirror.save();
        throttledPreview();
    });

    preview();
};