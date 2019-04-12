const initCheckBox = () => {
  checkInputs();
  $("#equipements input").addClass("hidden");

  $("#equipements label").click( (event) => {
      $(event.target).parent().toggleClass('transparent');
   });
  };

  const checkInputs = () => {
    $("#equipements input:checked").each((l, input) => {
      $(input).parent().removeClass('transparent');
    });
  };


export { initCheckBox };
