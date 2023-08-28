import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-message"
export default class extends Controller {
  static targets = [
    "searchForm", 
    "searchQuery", 
    "messageForm",
    "searchResults", 
    "messageReceiver",
    "messageBox",
    "messageButton",
  ]

  initialize() {
    // this.search = debounce(this.search.bind(this), 300);

    // Closing the New Message Modal
    this.element.addEventListener("hide.bs.modal", () => {
      // Reset everything
      this.searchFormTarget.reset();
      this.searchQueryTarget.readOnly = false;
      this.searchQueryTarget.style.fontWeight = 'normal';
      
      // Reset Search Results
      if (this.hasSearchResultsTarget) {
        this.searchResultsTarget.innerHTML = "";
      }
      
      this.messageFormTarget.reset();
      this.messageBoxTarget.style.display = "none";
    });
  }
  
  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.searchFormTarget.requestSubmit();
    }, 300)
  }
  
  setUser(event) {
    const target = event.target;
    const username = target.dataset.username;
    const userId = target.dataset.user;
    const radioButton = target.querySelector('.user-radio');

    // Set the search field to username of the clicked user
    this.searchQueryTarget.value = username;
    this.searchQueryTarget.readOnly = true;
    this.searchQueryTarget.style.fontWeight = 'bold';

    // Set the hidden field of the clicked user id to hidden field of the form of the message
    this.messageReceiverTarget.value = userId;
    
    // Check the radio button
    radioButton.checked = true;

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      // Remove the search results
      this.searchResultsTarget.innerHTML = "";

      // Show the message input box for the new message
      this.messageBoxTarget.style.display = "block";
      this.messageBoxTarget.select();

      // Enable the Chat button
      this.messageButtonTarget.disabled = false;
    }, 300)

  }

  submit() {
    this.messageFormTarget.requestSubmit();
  }
}
