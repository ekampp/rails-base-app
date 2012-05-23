// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// NOTE: You should not add modernizr here, as rails-boilerplate will include application.js at the bottom
//       of the page, and include modernizr manually at the top.
//
//= require plugins
//= require jquery
//= require jquery_ujs
//= require iphone-style-checkboxes
//= require iphone-style-checkboxes-config
//= require quickpager.jquery
//= require_tree .

/*
 * Observes the info-box data-remove-box elements, to remove the parenting box.
 *
 */
$(".info-remove").each(function(i, obj) {
  var obj = $(obj);
  obj.click(function(){
    obj.parent(".info-box").remove();
  });
});

/*
 * Paginates all .paginate objects
 *
 */
$(".paginate").quickPager({
  pagerLocation: 'after'
});
