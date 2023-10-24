// ==UserScript==
// @match https://www.youtube.com/*
// @match https://www.reddit.com/*
// ==/UserScript==

// Using code snippet from:
// https://www.reddit.com/r/qutebrowser/comments/zmqey6/comment/j0czmul/?utm_source=share&utm_medium=web2x&context=3

// Note:
// This seems to disable the smart image darkmode setting I set for certain websites,
// and use their native dark mode so to speak.

const meta = document.createElement('meta');
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
