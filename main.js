/**
 * Listens for the app launching then creates the window
 *
 * @see http://developer.chrome.com/apps/app.window.html
 */
var appWin = null;
var prevBounds = null;
chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('web/main.html', {
  	id: "TeslaApp",
    width: 400,
    height: 600,
  }, onWindowCreated);
});
      

function onWindowCreated(win){
	appWin = win;
	prevBounds = appWin.getBounds();
	appWin.onBoundsChanged.addListener(onBoundsChanged);
}

var counter = 0;
function onBoundsChanged() {
	if(!appWin.isMaximized()){
	counter++;
	function delayResize() {
		thiscounter = counter;
		setTimeout(function(){
			if(!appWin.isMaximized()){
				if(thiscounter == counter){
					newBounds = appWin.getBounds();
					if(newBounds.height != prevBounds.height){
						newBounds.width = Math.floor( newBounds.height*(2/3));
						prevBounds = newBounds;
						
						appWin.setBounds(newBounds);

					} else if (newBounds.width != prevBounds.width){
						newBounds.height = Math.floor( newBounds.width*1.5);
						prevBounds = newBounds;

						appWin.setBounds(newBounds);
						
					}
					prevBounds.left = newBounds.left;
					prevBounds.top = newBounds.top;
					counter = 0;
				}
			}
		}, 1000)
	}
	delayResize();
	}
}