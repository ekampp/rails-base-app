# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http:##example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require fancybox
#= require bootstrap
#= require_tree .

# Slabtext all `.slab-this` classes. This is delayed 100 miliseconds to allow
# the dom to completely render.
setTimeout \
  ->$(".slab-this").slabText({ fontRatio: 1.2 }),
  100

$("a.direct-contact-option").each (i, link) ->
  html = $("<h1></h1>").html($(link).data("contact-information")).addClass("huge")
  $(link).fancybox
    content: html
