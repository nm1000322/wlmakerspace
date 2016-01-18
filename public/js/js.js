$("#hiddenChangePass").hide();
/*$(".alert.alert-success.alert-dismissible.email").hide();*/
$('#coachlogin').click(function(){
    $('#mymodal').modal('show')
})

Mousetrap.bind('up up down down left right left right b a enter', function(e) {

    console.log("Hey! Konami! High Five!");
    $('.modal.fade.perms')
        .modal('show')
    ;
})

$('.datepicker').pickadate({
    min: +2,
    max: +18
});

$('.timepicker').pickatime({
        min: new Date(2015,3,20,10),
        max: new Date(2015,7,14,18,30)
});

$("#trainingrequest").validate();

$('#postCreate').validate();

$("#myModal").validate();

$('#newblogpost').click(function(){
    $('#postCreate').modal('show')
})


$('#showChangePass').click(function(){
    $('#hiddenChangePass').fadeIn();
})

$('.blogPost').readmore({
    speed: 75,
    lessLink: '<a href="#">Read less</a>'
})
$('.delete').click(function(){
    $('#postDelete').modal('show')
})
$('#openSuggest').click(function(){
    $('#suggestionModal').modal('show')
})

