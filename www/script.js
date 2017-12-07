(function() {
	'use strict';
	document.onload = function() {
		var radio = document.querySelectorAll('#map.sex label');
		for(var i = 0; i < radio.length; i++) {
			radio[i].onclick = function() {
				alert('lol');
			};
		}
	}
})();