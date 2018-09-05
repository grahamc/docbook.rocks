/* This file is NOT part of highlight.js */
document.onreadystatechange = function () {
    var examples = document.querySelectorAll('.example');
    for (var i = 0; i < examples.length; ++i) {
        var example = examples[i];
        var id = example.childNodes[0].id; // [0] is always <a id="..." />
        if (id.includes("xml")) {
            for (var j = 0; j < example.childNodes.length; ++j) {
                var examplecontent = example.childNodes[j];
                if (examplecontent.classList.contains("example-contents")) {
                    for (var k = 0; k < examplecontent.childNodes.length; ++k) {
                        var pre = examplecontent.childNodes[k];
                        if (pre.tagName == "PRE") {
                            pre.classList.add("language-xml");
                            // Some code samples will produce a programlisting
                            // themselves, but the ID should only explicitly
                            // set the language for the first case: the source.
                            break
                        }
                    }
                }
            }
        }
    }

    var listings = document.querySelectorAll('.programlisting');
    for (var l = 0; l < listings.length; ++l) {

        hljs.highlightBlock(listings[l]);
    }
}
