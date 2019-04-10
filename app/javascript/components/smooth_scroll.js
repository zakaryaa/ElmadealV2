$('.nav a').click(function() {
    //Toggle Class
    $("div.padded li.active").removeClass("active");
    $(this).closest('li').addClass("active");
    var theClass = $(this).attr("class");
    $('.' + theClass).parent('li').addClass('active');
    //Animate
    $('html, body').stop().animate({
        scrollTop: $($(this).attr('href')).offset().top - 160
    }, 400);
    return false;
});

$('a.scrollTop').scrollTop();