import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invite"
export default class extends Controller {
  select() {
    const inviteUser = this.element;
    const inviteList = inviteUser.parentElement;
    const inviteUsers = inviteList.querySelectorAll('.invite-user');

    inviteUsers.forEach(user => {
      user.classList.remove("selected");
    });
    inviteUser.classList.add("selected");
  }
}
