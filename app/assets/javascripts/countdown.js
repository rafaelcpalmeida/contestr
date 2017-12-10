var close_time = $('#close_time').html();
var countDownDate = new Date(close_time).getTime();

var x = setInterval(function() {
    var now = new Date().getTime();
    var distance = countDownDate - now;
    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((distance % (1000 * 60)) / 1000);

    var string = "";

    if (days > 0){
        string = days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
    }else if (days === 0 && hours > 0){
        string = hours + "h " + minutes + "m " + seconds + "s ";
    }else if (days === 0 && hours === 0 && minutes > 0){
        string = minutes + "m " + seconds + "s ";
    }else if (days === 0 && hours === 0 && minutes === 0){
        string = seconds + "s ";
    }

    if (distance < 0) {
        clearInterval(x);
        $('#remaining_time').html("Expirado");
    }else{
        $("#remaining_time").html(string);
    }
}, 1000);

$(document).ready(function() {
    $("select").material_select();
});

YUI().use("aui-ace-editor", function(Y) {
        var editor = new Y.AceEditor(
            {
                boundingBox: "#myEditor",
                value: "Cole aqui o código.",
                width: "absolute"
            }
        ).render();
    }
);

function replaceAll(str, needle, replacement) {
    return str.split(needle).join(replacement);
}

function getCode(){
    document.getElementById("submission_code").value = replaceAll(ace.edit("myEditor").getValue(), "\n", "<br>");
}