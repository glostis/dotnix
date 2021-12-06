// ==UserScript==
// @match https://docs.google.com/*
// ==/UserScript==

const meta = document.createElement('meta');
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
