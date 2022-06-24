// ==UserScript==
// @match https://docs.google.com/*
// @match https://*github.com/*
// ==/UserScript==

// This greasemonkey script "whitelists" websites with the `match` statements
// from qutebrowser's darkmode.
// Source: https://github.com/qutebrowser/qutebrowser/issues/5542#issuecomment-782040210

const meta = document.createElement('meta');
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
