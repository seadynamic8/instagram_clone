import * as FilePond from 'filepond';

import FilePondPluginImagePreview from 'filepond-plugin-image-preview';
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type';

// import { debounce } from "debounce";


document.addEventListener("turbo:load", loadFilePond);

function loadFilePond() {
  // Register the plugin
  FilePond.registerPlugin(
    FilePondPluginImagePreview, 
    FilePondPluginFileValidateType
  );
  
  
   // Get a reference to the file input element
   const inputElement = document.querySelector('#post-images');
  
   // Create a FilePond instance
   const pond = FilePond.create(inputElement, {
    credits: {},
    storeAsFile: true,
    allowMultiple: true,
    allowReorder: true,
    acceptedFileTypes: ['image/*'],
   });
}