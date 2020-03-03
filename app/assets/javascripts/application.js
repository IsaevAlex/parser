// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require materialize

// $(document).ready(function(){
//     $('#modal1').modal();
//     $('#modal2').modal();
// });

// $(document).on('ready', function(event) {
//     $(".dropdown-trigger").dropdown();
// });
//
// $(document).on('ready page:load', function(event) {
//     $(".dropdown-trigger").dropdown();
// });

$(document).on('page:partial-load', function(event) {
    $(".dropdown-trigger").dropdown();
});
