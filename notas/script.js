window.onload = function () {
    pageTitle();     // set the page title to something appropriate.
    smallCaps();     // sections begin with a few words in small caps.
    wordCount();     // a wordcount appears at the end of the page.
    hoverNotes();    // hover over a footnote number to see the note.
    bibLink();       // add link to bibliography below footnotes, if present.
    followHeading(); // note the heading of the current section at the top
};

function smallCaps() {
    const selector = "h3 + p, h4 + p, blockquote.epigraph + p";
    const ps = document.querySelectorAll(selector);
    for (var i = 0; i < ps.length; i++) {
        let p = ps[i];
        // store first 4 words, and remove them
        let four = p.innerHTML.split(" ").slice(0, 4).join(" ");
        p.innerHTML = p.innerHTML.replace(four, "");
        // reinsert the first 4 words in small-caps
        let sc = "<span class=sc>";
        sc += four + "</span>";
        p.insertAdjacentHTML("afterbegin", sc);
    }
}

function wordCount() {
    let content = document.getElementsByClassName("content")[0];
    if (!content) return;
    let words = 0;
    let x = document.createElement("p");
    x.id = "wordcount";
    content
        .querySelectorAll("p")
        .forEach((x) => (words += x.innerText.split(" ").length));
    x.innerText = words + " words";
    document.body.appendChild(x);
}

function hoverNotes() {
    let hov = document.createElement("div");
    hov.id = "hover-note";
    document.body.appendChild(hov);

    let ns = document.querySelectorAll(".footnote-ref");
    ns.forEach((n) => {
        n.onmouseenter = (e) => {
            hov.style.opacity = "1";
            hov.style.top = e.clientY;
            let t = document.querySelector(n.attributes.href.value).innerHTML;
            t = t.replace("↩", "");
            hov.innerHTML = t;
        };
        n.onmouseleave = (e) => {
            hov.style.opacity = "0";
            hov.style.top = -900;
        };
    });
}

function pageTitle() {
    let h2 = document.querySelector("h2");
    if (!h2) return;
    document.title = h2.innerText + " - Maga's Philosophy Notes";
}

function bibLink() {
    let fn = document.querySelector(".footnotes ol");
    if (!fn) return;
    let bl = document.createElement("a");
    bl.href = "bibliography.html";
    bl.id = "biblink";
    bl.innerText = "Bibliography";
    fn.parentNode.insertBefore(bl, fn.nextSibling);
}

function followHeading() {
    let first_header = document.querySelector("h2");
    if (!first_header) return;

    let follow = document.createElement("div");
    follow.id = "moving-header";
    document.body.appendChild(follow);

    document.addEventListener("scroll", () => {
        if (first_header.getBoundingClientRect().bottom > 0) {
            follow.innerHTML = "";
        }

        let pattern = "h2, h3, h4:not(#author):not(.subtitle)";
        let headers = document.querySelectorAll(pattern);
        headers.forEach((h) => {
            if (h.getBoundingClientRect().top < 20) {
                follow.innerHTML = h.innerHTML;
            }
        });

        let notes = document.querySelector(".footnotes");
        if (notes && notes.getBoundingClientRect().top <= 70) {
            follow.innerHTML = "";
        }
    });
}
