$(".datepicker").pickadate({
    selectMonths: true,
    selectYears: 15,
    today: "Hoje",
    clear: "Limpar",
    close: "Ok",
    closeOnSelect: false
});

$(".timepicker").pickatime({
    default: "Atual",
    fromnow: 0,
    twelvehour: false,
    donetext: "OK",
    cleartext: "Limpar",
    canceltext: "Cancelar",
    autoclose: false,
    ampmclickable: true,
    aftershow: function(){}
});