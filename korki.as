package 
{

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import se.svt.caspar.template.CasparTemplate;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class korki extends CasparTemplate
	{

		var imagesXML:XML;
		var xmlLoader:URLLoader = new URLLoader();
		private var timer:Timer;// = new Timer(2000);

		public function korki()
		{
			// constructor code
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.load(new URLRequest("dane_korkowe.xml"));
		}
		//overridden Stop that initiates the outro animation. IMPORTANT, it is very important when you override Stop to later call super.Stop() or removeTemplate()
		override public function Stop():void
		{
			//do the outro animation
		}
		//overridden Play that will initiate the intro animation and start the timer if there is data
		override public function Play():void
		{
			//do the intro animation
		}
		function xmlLoaded(evt:Event):void
		{
			imagesXML = XML(xmlLoader.data);
			mainLoader.load(new URLRequest(imagesXML.mapa.@file));
			mainLoader.addEventListener(Event.COMPLETE, fileLoaded);
			titlesLoader.load( new URLRequest(imagesXML.legenda.@file));
			titlesLoader.addEventListener(Event.COMPLETE, titlesLoaded);
			legendLoader.load( new URLRequest(imagesXML.opis1.@file));
			legendLoader.addEventListener(Event.COMPLETE, legendLoaded);
		}
		function fileLoaded(evt:Event):void
		{
			mainLoader.scaleContent = false;
			//mainLoader.content.width = 1024;
			//mainLoader.content.height = 576;
			mainLoader.content.scaleX = 0.30;
			mainLoader.content.scaleY = 0.30;//0.14;
			mainLoader.content.x = -200;
			mainLoader.content.y = -300;
			timer = new Timer(2000);

			timer.addEventListener(TimerEvent.TIMER, introZoom);
			timer.start();
			TweenLite.to(titlesLoader.content, 1, {alpha:1});
			//TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1});
			//introZoom();
		}
		function titlesLoaded(evt:Event):void
		{
			titlesLoader.content.alpha = 0;
		}
		function legendLoaded(evt:Event):void
		{
			legendLoader.content.alpha = 0;
		}
		function introZoom(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, introZoom);
			timer = null;
			//TweenLite.to(mainLoader.content, 1, {scaleX:1, scaleY:1});
			// to jest pierwsza pozycja
			//TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:-2360, y:-2800});
			//TweenLite.to(legendLoader.content, 3, {alpha:1});
			legendHide();
		}
		function positionLoop():void
		{
			// to jest pierwsza pozycja
			TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:-2360, y:-2800, onComplete:legendShow});
		}
		function legendShow():void
		{
			TweenLite.to(legendLoader.content, 1, {alpha:1});
			waitLoop();
		}
		function legendHide():void
		{
			//to musi działać dodać jakiś warunek
//111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
			//timer.removeEventListener(TimerEvent.TIMER, introZoom);
			//timer = null;
			TweenLite.to(legendLoader.content, 1, {alpha:0, onComplete:positionLoop});
		}
		function waitLoop():void
		{
			timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, legendHide);
			timer.start();
		}

	}

}