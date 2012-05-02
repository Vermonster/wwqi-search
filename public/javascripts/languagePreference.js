$(function () {

  $('.lang-selector').click(function () {
    var langRegex = /\/(fa|en)\//;
    var matches = langRegex.exec($(this).attr('href'));

    if (matches[1]) { $.cookie("languagePref", matches[1]); }

    alert("Cookie is " + $.cookie("languagePref"));
  });

});
