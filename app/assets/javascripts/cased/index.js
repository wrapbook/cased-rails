//= require rails-ujs

const receiveMessage = (event) => {
  if (!event.isTrusted) {
    return;
  }

  const { user } = event.data;
  casedUser.innerText = user;
  if (casedCreateSession) {
    casedCreateSession.submit();
  } else {
    casedLoggedInContainer.classList.remove("hidden");
    casedLoggedOutContainer.classList.add("hidden");
  }
};

let windowReference = null;
let previousUrl = null;
let casedCreateSession = null;
let casedLoggedInContainer = null;
let casedLoggedOutContainer = null;
let casedUser = null;

const openSignInWindow = (url) => {
  window.removeEventListener("message", receiveMessage);
  const windowFeatures =
    "toolbar=no, menubar=no, width=600, height=700, top=50, left=200";

  if (windowReference === null || windowReference.closed) {
    windowReference = window.open(url, "Cased", windowFeatures);
  } else if (previousUrl !== url) {
    // If the window is already open and the previous URL was different, we need
    // to load a new URL and refocus.
    windowReference = window.open(url, "Cased", windowFeatures);
    windowReference.focus();
  } else {
    windowReference.focus();
  }

  window.addEventListener("message", (event) => receiveMessage(event), false);
  previousUrl = url;
};

window.addEventListener("DOMContentLoaded", (event) => {
  // Global elements
  casedCreateSession = document.getElementById("cased-create-session");
  casedLoggedInContainer = document.getElementById("cased-logged-in");
  casedLoggedOutContainer = document.getElementById("cased-logged-out");
  casedUser = document.getElementById("cased-user");

  // Local elements
  const casedAuthenticate = document.getElementById("cased-authenticate");
  if (casedAuthenticate) {
    casedAuthenticate.addEventListener("click", (event) => {
      event.preventDefault();

      openSignInWindow(event.currentTarget.href);
    });
  }

  const casedLogout = document.getElementById("cased-logout");
  if (casedLogout) {
    casedLogout.addEventListener("ajax:success", (_event) => {
      casedLoggedInContainer.classList.add("hidden");
      casedLoggedOutContainer.classList.remove("hidden");
    });
  }
});
