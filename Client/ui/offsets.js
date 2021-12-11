


const atype_input = document.getElementById("atype")
const abone_input = document.getElementById("abone")

const model_input = document.getElementById("model")
const ASK_button = document.getElementById("SKMesh")
const ASM_button = document.getElementById("SM")
const ALight_button = document.getElementById("ALight")

const Destroy_button = document.getElementById("Destroy")

let Scale_Inputs = [
    document.getElementById("sm_sx"),
    document.getElementById("sm_sy"),
    document.getElementById("sm_sz"),
]

let Offsets_Buttons = [
    document.getElementById("attachedx"),
    document.getElementById("attachedy"),
    document.getElementById("attachedz"),

    document.getElementById("attachedrx"),
    document.getElementById("attachedry"),
    document.getElementById("attachedrz"),
]

Offsets_Buttons.forEach(function(v, i, array) {
    v.oninput = function() {
        Events.Call("UpdateOffsets", Offsets_Buttons[0].value, Offsets_Buttons[1].value, Offsets_Buttons[2].value, Offsets_Buttons[3].value, Offsets_Buttons[4].value, Offsets_Buttons[5].value);
    };
});

ASM_button.onclick = function() {
    Events.Call("ASM", atype_input.value, abone_input.value, model_input.value, Scale_Inputs[0].value, Scale_Inputs[1].value, Scale_Inputs[2].value)
}

ALight_button.onclick = function() {
    Events.Call("ALight", atype_input.value, abone_input.value)
}

Destroy_button.onclick = function() {
    Events.Call("ADestroy")
}