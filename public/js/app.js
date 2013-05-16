(function() {
  var myScript;

  myScript = {
    init: function() {
      return alert('hello');
    }
  };

  myScript.init();

  myScript = {
    init: function() {
      return alert('hello');
    }
  };

  myScript.init();

}).call(this);
