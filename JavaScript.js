function validatetextbox1(textboxname,Message) {
    var initialvalidate = true;
    var gettextboxvalue = textboxname.value.trim();
    if (gettextboxvalue === "") {
        textboxname.focus();
        alert(Message);
        initialvalidate = false;
    }
    return initialvalidate;
}