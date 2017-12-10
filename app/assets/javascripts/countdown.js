var countDownDate = new Date(close_time).getTime();
function escapeHTML(str) { return str.replace(/[&"'<>]/g, (m) => ({ "&": "&amp;", '"': "&quot;", "'": "&#39;", "<": "&lt;", ">": "&gt;" })[m]); }
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

    document.getElementById("remaining_time").innerHTML = escapeHTML(string);
    if (distance < 0) {
        clearInterval(x);
        document.getElementById("remaining_time").innerHTML = escapeHTML("Expirado");
    }
}, 1000);

$(document).ready(function() {
    $('select').material_select();
});

YUI().use('aui-ace-editor', function(Y) {
        var editor = new Y.AceEditor(
            {
                boundingBox: '#myEditor',
                value: "Cole aqui o código.",
                width: "absolute"
            }
        ).render();
    }
);
/*
String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
*/

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(find, 'g'), replace);
}

function getCode(){
    //document.getElementById("submission_code").value = ace.edit("myEditor").getValue().replaceAll("\n","<br>");
    document.getElementById("submission_code").value = replaceAll(ace.edit("myEditor").getValue(), "\n", "<br>");
}