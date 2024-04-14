// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

Turbo.setConfirmMethod((message, element) => {
  let dialog = document.getElementById("delete_modal");
  dialog.querySelector("h3").textContent = message;
  dialog.showModal();

  return new Promise((resolve, reject) => {
    const onDialogClose = () => {
      resolve(dialog.returnValue === "confirm");
      dialog.removeEventListener("close", onDialogClose);
    };
    dialog.addEventListener("close", onDialogClose, { once: true });
  });
});

